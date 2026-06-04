@{
    RootModule        = '.\Devolutions.PowerShellUniversal.Apps.NetworkUtilities.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '68c73ac9-a77e-4360-8df4-cf91af025e6f'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Network utilities built with PowerShell Universal. Resolve DNS names, scan networks, and run speed tests.'
    FunctionsToExport = @(
        'New-NetworkUtilityApp'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'network', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/NetworkUtilities'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}

