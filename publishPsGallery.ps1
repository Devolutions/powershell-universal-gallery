Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion '1.1.0-rc3' -Force -AllowPrerelease
Register-PSResourceRepository -PSGallery -Trusted

$InputPath = Join-Path $PSScriptRoot $env:inputpath

$PublishSplat = @{
    Path       = $InputPath
    Repository = "PSGallery"
    ApiKey     = $env:apitoken
}

Publish-PSResource @PublishSplat