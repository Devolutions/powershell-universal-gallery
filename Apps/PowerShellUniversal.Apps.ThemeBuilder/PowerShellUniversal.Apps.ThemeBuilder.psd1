@{
    RootModule        = 'PowerShellUniversal.Apps.ThemeBuilder.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '62985152-adc7-4adf-bc11-105a38620c94'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Theme builder app for PowerShell Universal.'
    FunctionsToExport = @(
        'New-PSUThemeBuilderApp'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', "PowerShellUniversal", 'theme', 'colors')
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.ThemeBuilder'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

