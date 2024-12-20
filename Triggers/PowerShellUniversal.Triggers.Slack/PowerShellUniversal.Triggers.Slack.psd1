@{
    RootModule        = 'PowerShellUniversal.Triggers.Slack.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'e9acdd48-8353-43d9-bedb-d87e8d8404ce'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Scripts for working with Slack.'
    RequiredModules   = @('PowerShellUniversal.Scripts')
    FunctionsToExport = @('Send-PSUSlackNotification')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', 'Slack', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/blob/main/Triggers/PowerShellUniversal.Triggers.Slack'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}