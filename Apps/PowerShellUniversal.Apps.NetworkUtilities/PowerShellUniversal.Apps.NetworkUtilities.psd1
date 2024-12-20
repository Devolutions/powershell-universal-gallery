@{
    RootModule        = '.\PowerShellUniversal.Apps.NetworkUtilities.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'de888971-43f0-4f7e-a61f-2f17678e3111'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Network utilities built with PowerShell Universal. Resolve DNS names, scan networks, and run speed tests.'
    FunctionsToExport = @(
        'New-NetworkUtilityApp'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'network', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.NetworkUtilities'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        }
    }
}

