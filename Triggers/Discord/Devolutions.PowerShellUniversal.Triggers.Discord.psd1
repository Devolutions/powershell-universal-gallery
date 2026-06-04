@{
    RootModule        = 'Devolutions.PowerShellUniversal.Triggers.Discord.psm1'
    ModuleVersion     = '1.0.1'
    GUID              = 'c6b4fd4a-7d9a-465b-a04d-a26077d2d43e'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Scripts for working with Discord.'
    RequiredModules   = @('Devolutions.PowerShellUniversal.Scripts')
    FunctionsToExport = @('Send-PSUDiscordNotification')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', 'Discord', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Triggers/Discord'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}