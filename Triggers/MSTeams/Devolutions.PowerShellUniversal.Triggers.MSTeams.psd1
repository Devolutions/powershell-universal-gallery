@{
    RootModule        = 'Devolutions.PowerShellUniversal.Triggers.MSTeams.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '7b9c309e-b282-4c49-ac98-7c6bb87a3da6'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Scripts for sending triggers to Microsoft Teams.'
    FunctionsToExport = @('Send-PSUTeamsNotification')
    PrivateData       = @{

        PSData = @{
            Tags       = @('script', "PowerShellUniversal", "triggers", "MSTeams")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Triggers/MSTeams'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}