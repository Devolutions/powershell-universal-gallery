@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.Random.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '0ec91ece-0e1e-409d-8251-9901a7224f38'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Random tools for apps.'
    FunctionsToExport = @(
        'New-UDRandom'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'random', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Random'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

