@{
    RootModule    = 'PowerShellUniversal.Apps.Earthquakes.psm1'
    ModuleVersion = '1.0.0'
    GUID          = '378b0fc7-120f-4b96-902b-3fa79b050f3d'
    Author        = 'Ironman Software'
    CompanyName   = 'Ironman Software'
    Copyright     = '(c) Ironman Software. All rights reserved.'
    Description   = 'An app that displays earthquakes in a map for the last 24 hours.'
    FileList      = @(".universal\dashboards.ps1")
    PrivateData   = @{
        PSData = @{
            Tags       = @('app', 'earthquakes', "PowerShellUniversal", "usgs")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.Earthquakes'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

