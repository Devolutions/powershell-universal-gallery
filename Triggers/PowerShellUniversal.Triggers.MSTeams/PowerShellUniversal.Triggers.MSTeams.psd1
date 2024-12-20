@{
    RootModule        = 'PowerShellUniversal.Triggers.MSTeams.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'cc203207-5dea-462e-896e-9ce46e731074'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Scripts for sending triggers to Microsoft Teams.'
    FunctionsToExport = @('Send-PSUTeamsNotification')
    PrivateData       = @{

        PSData = @{
            Tags       = @('script', "PowerShellUniversal", "triggers", "MSTeams")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Triggers/PowerShellUniversal.Triggers.MSTeams'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}