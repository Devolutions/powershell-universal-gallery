@{
    RootModule        = 'PowerShellUniversal.Triggers.Discord.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'be654e36-c308-477f-b6ba-214ed2726e78'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Scripts for working with Discord.'
    RequiredModules   = @('PowerShellUniversal.Scripts')
    FunctionsToExport = @('Send-PSUDiscordNotification')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', 'Discord', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/blob/main/Triggers/PowerShellUniversal.Triggers.Discord'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}