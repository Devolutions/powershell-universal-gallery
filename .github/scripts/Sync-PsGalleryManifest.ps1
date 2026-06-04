param(
    [string]$ManifestPath = (Join-Path $PSScriptRoot '..\..\manifest.json'),
    [string]$PublishedAfter,
    [switch]$ForceFullSync
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SourceName = 'PowerShellGallery'
$SourceBaseUri = 'https://www.powershellgallery.com'
$FeedBaseUri = "$SourceBaseUri/api/v2"
$AtomNamespaces = @{
    atom = 'http://www.w3.org/2005/Atom'
    d = 'http://schemas.microsoft.com/ado/2007/08/dataservices'
    m = 'http://schemas.microsoft.com/ado/2007/08/dataservices/metadata'
}
$ParsedPublishedAfter = $null

if (-not [string]::IsNullOrWhiteSpace($PublishedAfter)) {
    $ParsedPublishedAfter = [datetime]::Parse(
        $PublishedAfter,
        [System.Globalization.CultureInfo]::InvariantCulture,
        [System.Globalization.DateTimeStyles]::AdjustToUniversal
    )
}

function Get-EntryValue {
    param(
        [Parameter(Mandatory)]
        [System.Xml.XmlElement]$Entry,
        [Parameter(Mandatory)]
        [string]$XPath
    )

    $node = Select-Xml -Xml $Entry -XPath $XPath -Namespace $AtomNamespaces | Select-Object -ExpandProperty Node -First 1
    if ($null -eq $node) {
        return $null
    }

    return $node.InnerText
}

function Get-FeedEntries {
    param(
        [Parameter(Mandatory)]
        [string]$Uri
    )

    $entries = [System.Collections.Generic.List[System.Xml.XmlElement]]::new()
    $nextUri = $Uri

    while ($nextUri) {
        Write-Host "Querying $nextUri"
        $response = Invoke-WebRequest -Uri $nextUri -Headers @{ Accept = 'application/atom+xml,application/xml' }
        $document = [xml]$response.Content

        foreach ($entryMatch in Select-Xml -Xml $document -XPath '/atom:feed/atom:entry' -Namespace $AtomNamespaces) {
            $entries.Add([System.Xml.XmlElement]$entryMatch.Node)
        }

        $nextLink = Select-Xml -Xml $document -XPath "/atom:feed/atom:link[@rel='next']" -Namespace $AtomNamespaces | Select-Object -ExpandProperty Node -First 1
        if ($null -ne $nextLink) {
            $nextUri = $nextLink.GetAttribute('href')
        }
        else {
            $nextUri = $null
        }
    }

    return $entries
}

function ConvertTo-ODataDateLiteral {
    param(
        [Parameter(Mandatory)]
        [datetime]$Value
    )

    $utcValue = $Value.ToUniversalTime()
    return "datetime'{0}'" -f $utcValue.ToString('yyyy-MM-ddTHH:mm:ssZ', [System.Globalization.CultureInfo]::InvariantCulture)
}

function New-ManifestItem {
    param(
        [Parameter(Mandatory)]
        [System.Xml.XmlElement]$Entry
    )

    $packageId = Get-EntryValue -Entry $Entry -XPath 'm:properties/d:Id'
    $version = Get-EntryValue -Entry $Entry -XPath 'm:properties/d:NormalizedVersion'
    if ([string]::IsNullOrWhiteSpace($version)) {
        $version = Get-EntryValue -Entry $Entry -XPath 'm:properties/d:Version'
    }

    $tags = (Get-EntryValue -Entry $Entry -XPath 'm:properties/d:Tags') -split '\s+' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    if ($tags -notcontains 'PowerShellUniversal') {
        return $null
    }

    $description = Get-EntryValue -Entry $Entry -XPath 'm:properties/d:Description'
    $projectUrl = Get-EntryValue -Entry $Entry -XPath 'm:properties/d:ProjectUrl'
    $iconUrl = Get-EntryValue -Entry $Entry -XPath 'm:properties/d:IconUrl'

    $manifestItem = [ordered]@{
        name = $packageId
        version = $version
        source = $SourceName
    }

    if (-not [string]::IsNullOrWhiteSpace($iconUrl)) {
        $manifestItem.iconUrl = $iconUrl
    }

    if (-not [string]::IsNullOrWhiteSpace($projectUrl)) {
        $manifestItem.projectUrl = $projectUrl
    }

    if (-not [string]::IsNullOrWhiteSpace($description)) {
        $manifestItem.description = $description.Trim()
    }

    return [pscustomobject]$manifestItem
}

function ConvertTo-NormalizedManifestItem {
    param(
        [Parameter(Mandatory)]
        [psobject]$Item
    )

    $version = $null
    if ($Item.PSObject.Properties.Name -contains 'version' -and -not [string]::IsNullOrWhiteSpace($Item.version)) {
        $version = $Item.version
    }
    elseif ($Item.PSObject.Properties.Name -contains 'currentVersion' -and -not [string]::IsNullOrWhiteSpace($Item.currentVersion)) {
        $version = $Item.currentVersion
    }
    elseif ($Item.PSObject.Properties.Name -contains 'versions' -and $null -ne $Item.versions) {
        $candidateVersions = @($Item.versions) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        if ($candidateVersions.Count -gt 0) {
            $version = $candidateVersions[0]
        }
    }

    $normalizedItem = [ordered]@{
        name = $Item.name
        version = $version
        source = $Item.source
    }

    foreach ($propertyName in 'iconUrl', 'projectUrl', 'description') {
        if ($Item.PSObject.Properties.Name -contains $propertyName -and -not [string]::IsNullOrWhiteSpace($Item.$propertyName)) {
            $normalizedItem[$propertyName] = $Item.$propertyName
        }
    }

    return [pscustomobject]$normalizedItem
}

function Import-ExistingManifest {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    $content = Get-Content -LiteralPath $Path -Raw
    if ([string]::IsNullOrWhiteSpace($content)) {
        return @()
    }

    return @(
        $content |
            ConvertFrom-Json |
            ForEach-Object { ConvertTo-NormalizedManifestItem -Item $_ }
    )
}

$resolvedManifestPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ManifestPath)
$existingManifest = Import-ExistingManifest -Path $resolvedManifestPath
$useIncrementalSync = $null -ne $ParsedPublishedAfter -and -not $ForceFullSync.IsPresent -and $existingManifest.Count -gt 0

$latestPackageFilter = @(
    'IsLatestVersion'
    'IsPrerelease eq false'
    "substringof('PowerShellUniversal',Tags)"
)

if ($useIncrementalSync) {
    $latestPackageFilter += 'Published gt {0}' -f (ConvertTo-ODataDateLiteral -Value $ParsedPublishedAfter)
}

$latestPackagesUri = '{0}/Packages()?$filter={1}&$orderby=Id&$top=100' -f $FeedBaseUri, [uri]::EscapeDataString(($latestPackageFilter -join ' and '))
$latestEntries = @(Get-FeedEntries -Uri $latestPackagesUri)

if (-not $useIncrementalSync -and $latestEntries.Count -eq 0 -and $existingManifest.Count -gt 0) {
    throw 'The PowerShell Gallery query returned no packages. Refusing to overwrite the existing manifest with an empty result.'
}

$manifestMap = [ordered]@{}
foreach ($item in $existingManifest) {
    $manifestMap[$item.name] = $item
}

foreach ($entry in $latestEntries) {
    $manifestItem = New-ManifestItem -Entry $entry
    if ($null -ne $manifestItem) {
        $manifestMap[$manifestItem.name] = $manifestItem
    }
}

$manifestItems = $manifestMap.Values
$manifestItems = @($manifestItems | Sort-Object -Property name)
$json = $manifestItems | ConvertTo-Json -Depth 5

$existingContent = if (Test-Path -LiteralPath $resolvedManifestPath) {
    Get-Content -LiteralPath $resolvedManifestPath -Raw
}
else {
    ''
}

$newContent = $json + [Environment]::NewLine
if ($existingContent -ceq $newContent) {
    Write-Host ('Manifest already up to date with {0} package entries.' -f $manifestItems.Count)
    return
}

Set-Content -LiteralPath $resolvedManifestPath -Value $json -Encoding utf8NoBOM
Write-Host ('Updated manifest with {0} package entries.' -f $manifestItems.Count)