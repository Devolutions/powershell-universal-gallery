@{
    RootModule        = 'Devolutions.PowerShellUniversal.Bluesky.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd6590c24-2fbf-4511-8b0a-263bed9da32c'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    FunctionsToExport = 'Send-PSUBlueskyPost', 'Get-PSUBlueskyFeed', 'New-PSUBlueskyFeedTable'
    Description       = 'Bluesky integration for PowerShell Universal.'
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'Bluesky', "PowerShellUniversal", "script")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Scripts/Bluesky'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    }
}