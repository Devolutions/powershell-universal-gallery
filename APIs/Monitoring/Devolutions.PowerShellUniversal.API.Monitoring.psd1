@{
    RootModule        = 'Devolutions.PowerShellUniversal.API.Monitoring.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'de4796d4-679a-487b-b2a2-42c50b78551a'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Server monitoring API for PowerShell Universal.'
    FunctionsToExport = @(
        'Invoke-PSUServerDataCollection'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @('Monitoring', 'api', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/APIs/Monitoring'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}

