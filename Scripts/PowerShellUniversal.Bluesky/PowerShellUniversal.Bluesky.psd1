@{
    RootModule        = 'PowerShellUniversal.Bluesky.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'e15350e6-c8ce-467d-b2c7-ee5e1350f4d0'
    Author            = 'Adam Driscoll'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    FunctionsToExport = 'Send-PSUBlueskyPost', 'Get-PSUBlueskyFeed', 'New-PSUBlueskyFeedTable'
    Description       = 'Bluesky integration for PowerShell Universal.'
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'Bluesky', "PowerShellUniversal", "script")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Scripts/PowerShellUniversal.Bluesky'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    }
}