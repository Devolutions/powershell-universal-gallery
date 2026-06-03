@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.Services.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a7255a37-0256-47bc-a9cf-65f73d30198b'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Service Manager for Windows.'
    FunctionsToExport = @(
        'New-PSUServiceApp',
        'New-PSUServiceTable',
        'New-PSUServiceProperties',
        'New-PSUServiceGeneral',
        'New-PSUServiceLogOn',
        'New-PSUServiceControlButtons'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'windows', "PowerShellUniversal", 'services')
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Services'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

