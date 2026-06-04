$InputPath = Join-Path $PSScriptRoot '..\..' $env:inputpath

$ManifestPath = Get-ChildItem -Path $InputPath -Filter *.psd1
$Manifest = Import-PowerShellDataFile -Path $ManifestPath.FullName

foreach ($RequiredModule in $Manifest.RequiredModules) {
    Install-Module -Name $RequiredModule -Force -Scope CurrentUser
}

$PublishSplat = @{
    Path        = $InputPath
    NuGetApiKey = $env:apitoken
}

Publish-Module @PublishSplat