@{
    ModuleVersion = '1.0.0'
    GUID          = '6ad43698-fb8b-4787-aa60-36c494ae8121'
    Author        = 'Ironman Software'
    CompanyName   = 'Ironman Software'
    Copyright     = '(c) Ironman Software. All rights reserved.'
    Description   = 'Adds a health check that checks for excessive runspace usage by the Universal server.'
    FileList      = @('.universal\healthChecks.ps1')
    PrivateData   = @{
        PSData = @{
            Tags       = @('health-check', 'PowerShell', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/HealthChecks/PowerShellUniversal.HealthCheck.ExcessiveRunspaces'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}

