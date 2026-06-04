@{
    RootModule    = 'Devolutions.PowerShellUniversal.Apps.Earthquakes.psm1'
    ModuleVersion = '1.0.0'
    GUID          = '6b0c9b6e-8cca-426c-9a94-f0ac98aa9bbb'
    Author        = 'Devolutions, Inc.'
    CompanyName   = 'Devolutions, Inc.'
    Copyright     = '(c) Devolutions, Inc. All rights reserved.'
    Description   = 'An app that displays earthquakes in a map for the last 24 hours.'
    FileList      = @(".universal\dashboards.ps1")
    PrivateData   = @{
        PSData = @{
            Tags       = @('app', 'earthquakes', "PowerShellUniversal", "usgs")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Earthquakes'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

