@{
    RootModule        = '.\Devolutions.PowerShellUniversal.Triggers.Email.psm1'
    ModuleVersion     = '1.0.4'
    GUID              = '98a690fe-523b-4d01-8015-409606de9a1f'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'A module that contains functions for sending emails when certain triggers take place in PowerShell Universal.'
    FunctionsToExport = @('Send-PSUTriggerEmail')
    RequiredModules   = @('Mailozaurr')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Triggers/Email'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}

