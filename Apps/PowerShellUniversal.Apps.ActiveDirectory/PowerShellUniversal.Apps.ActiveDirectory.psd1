@{
    RootModule    = '.\PowerShellUniversal.Apps.ActiveDirectory.psm1'
    ModuleVersion = '1.0.0'
    GUID          = '393d9a26-246a-4769-8595-a382b4e8ff7a'
    Author        = 'Ironman Software'
    CompanyName   = 'Ironman Software'
    Copyright     = '(c) Ironman Software. All rights reserved.'
    Description   = 'Active Directory tools built with PowerShell Universal. Reset passwords, restore deleted users, manage group membership and search for objects.'
    FileList      = @(".universal\dashboards.ps1")
    PrivateData   = @{
        PSData = @{
            Tags        = @('app', 'ActiveDirectory', "PowerShellUniversal")
            LicenseUri  = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri  = 'https://github.com/ironmansoftware/scripts/tree/main/ActiveDirectory/PowerShellUniversal.Apps.ActiveDirectory'
            IconUri     = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
            DisplayName = 'Active Directory App'
        } 
    } 
}

