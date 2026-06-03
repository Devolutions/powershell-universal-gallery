@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.ThemeBuilder.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '77c9fc70-945c-4d59-a49c-e114ddf38edb'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Theme builder app for PowerShell Universal.'
    FunctionsToExport = @(
        'New-PSUThemeBuilderApp'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', "PowerShellUniversal", 'theme', 'colors')
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/ThemeBuilder'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

