@{
    RootModule        = 'PowerShellUniversal.Weather.Apps.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '31cf3a26-715a-454a-ab6b-e291660d4f0b'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Weather components for PowerShell Universal Apps.'
    FunctionsToExport = @(
        'New-UDWeatherCard'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'weather', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Misc/PowerShellUniversal.Weather.Apps'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

