@{
    RootModule        = 'Devolutions.PowerShellUniversal.Weather.Apps.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'fdfa406e-855b-4b8f-bea2-7b6b87a8b2dc'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Weather components for PowerShell Universal Apps.'
    FunctionsToExport = @(
        'New-UDWeatherCard'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'weather', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Weather'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

