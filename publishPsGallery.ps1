$InputPath = Join-Path $PSScriptRoot $env:inputpath

$PublishSplat = @{
    Path        = $InputPath
    NuGetApiKey = $env:apitoken
}

Publish-Module @PublishSplat