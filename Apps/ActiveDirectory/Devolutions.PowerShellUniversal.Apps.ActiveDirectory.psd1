@{
    RootModule    = '.\Devolutions.PowerShellUniversal.Apps.ActiveDirectory.psm1'
    ModuleVersion = '1.0.0'
    GUID          = '6027dd29-9af7-4b8d-a471-979b19aa342c'
    Author        = 'Devolutions, Inc.'
    CompanyName   = 'Devolutions, Inc.'
    Copyright     = '(c) Devolutions, Inc. All rights reserved.'
    Description   = 'Active Directory tools built with PowerShell Universal. Reset passwords, restore deleted users, manage group membership and search for objects.'
    FileList      = @(".universal\dashboards.ps1")
    PrivateData   = @{
        PSData = @{
            Tags        = @('app', 'ActiveDirectory', "PowerShellUniversal")
            LicenseUri  = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri  = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/ActiveDirectory'
            IconUri     = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
            DisplayName = 'Active Directory App'
        } 
    } 
}

