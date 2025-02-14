@{
    RootModule        = '.\PowerShellUniversal.Triggers.Email.psm1'
    ModuleVersion     = '1.0.3'
    GUID              = '7f0e3a9c-0f9d-438f-86cf-0ef61cf0b27f'
    Author            = 'Ironman Software, LLC'
    CompanyName       = 'Ironman Software, LLC'
    Copyright         = '(c) Ironman Software, LLC. All rights reserved.'
    Description       = 'A module that contains functions for sending emails when certain triggers take place in PowerShell Universal.'
    FunctionsToExport = @('Send-PSUTriggerEmail')
    RequiredModules   = @('Mailozaurr')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Triggers/PowerShellUniversal.Triggers.Email'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}

