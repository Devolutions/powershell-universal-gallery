$InputPath = Join-Path $PSScriptRoot '..\..' $env:inputpath

if (-not (Test-Path -LiteralPath $InputPath -PathType Container)) {
    throw "Module path not found: $InputPath"
}

$ManifestPath = Get-ChildItem -Path $InputPath -Filter *.psd1 -File

if ($ManifestPath.Count -ne 1) {
    throw "Expected exactly one module manifest in $InputPath but found $($ManifestPath.Count)."
}

$Manifest = Import-PowerShellDataFile -Path $ManifestPath.FullName

foreach ($RequiredModule in $Manifest.RequiredModules) {
    Install-Module -Name $RequiredModule -Force -Scope CurrentUser
}

$PublishSplat = @{
    Path        = $InputPath
    NuGetApiKey = $env:apitoken
}

Publish-Module @PublishSplat