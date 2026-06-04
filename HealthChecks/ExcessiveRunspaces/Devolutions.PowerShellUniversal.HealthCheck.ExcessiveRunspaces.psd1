@{
    ModuleVersion = '1.0.0'
    GUID          = 'e706c37f-ba87-4db4-bc00-6ae6fe54d9c9'
    Author        = 'Devolutions, Inc.'
    CompanyName   = 'Devolutions, Inc.'
    Copyright     = '(c) Ironman Software. All rights reserved.'
    Description   = 'Adds a health check that checks for excessive runspace usage by the Universal server.'
    FileList      = @('.universal\healthChecks.ps1')
    PrivateData   = @{
        PSData = @{
            Tags       = @('health-check', 'PowerShell', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/HealthChecks/ExcessiveRunspaces'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}

