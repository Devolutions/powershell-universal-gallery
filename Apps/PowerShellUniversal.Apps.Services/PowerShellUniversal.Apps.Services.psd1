@{
    RootModule        = 'PowerShellUniversal.Apps.Services.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '55993d8a-a137-4818-86b6-72cc7fac9971'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
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
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.Services'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

