@{
    RootModule        = 'Devolutions.PowerShellUniversal.Scripts.psm1'
    ModuleVersion     = '1.0.2'
    GUID              = 'f6d2e044-db46-4034-b5d8-3380ba4ec4b6'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'A collection of scripts for PowerShell Universal.'
    FunctionsToExport = @('Format-PSUJobDescription')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Scripts/Universal'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}