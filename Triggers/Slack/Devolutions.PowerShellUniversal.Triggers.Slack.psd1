@{
    RootModule        = 'Devolutions.PowerShellUniversal.Triggers.Slack.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'f106ae98-81a5-47d4-b4fa-c775f10b0ce6'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Scripts for working with Slack.'
    RequiredModules   = @('Devolutions.PowerShellUniversal.Scripts')
    FunctionsToExport = @('Send-PSUSlackNotification')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', 'Slack', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Triggers/Slack'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}