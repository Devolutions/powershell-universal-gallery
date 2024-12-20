@{
    ModuleVersion = '1.0.0'
    GUID          = '67e7a5f3-db9a-4763-bfb4-9f4cfc6f4432'
    Author        = 'Ironman Software'
    CompanyName   = 'Ironman Software'
    Copyright     = '(c) Ironman Software. All rights reserved.'
    Description   = 'Features for integrating with Active Directory security.'
    FileList      = @(
        '.universal\roles.ps1'
    )
    PrivateData   = @{
        PSData = @{
            Tags       = @('security', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Roles/PowerShellUniversal.Roles.ActiveDirectory'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}

