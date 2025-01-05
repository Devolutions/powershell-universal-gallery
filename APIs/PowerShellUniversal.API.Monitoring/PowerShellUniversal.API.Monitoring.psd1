@{
    RootModule        = 'PowerShellUniversal.API.Monitoring.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a15b9378-0368-4e86-8178-8e7874f9f4a6'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Server monitoring API for PowerShell Universal.'
    FunctionsToExport = @(
        'Invoke-PSUServerDataCollection'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @('Monitoring', 'api', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/APIs/PowerShellUniversal.API.Monitoring'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}

