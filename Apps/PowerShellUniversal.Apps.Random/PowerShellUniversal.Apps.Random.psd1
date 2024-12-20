@{
    RootModule        = 'PowerShellUniversal.Apps.Random.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '724f87cd-4f6d-484a-8a1d-3c4c1258d5f4'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Random tools for apps.'
    FunctionsToExport = @(
        'New-UDRandom'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'random', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.Random'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

