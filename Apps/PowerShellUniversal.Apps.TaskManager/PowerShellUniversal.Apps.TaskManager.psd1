@{
    RootModule        = 'PowerShellUniversal.Apps.TaskManager.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '5d215763-5a86-406b-b7eb-cd879dfcbf6a'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Task Manager for PowerShell Universal.'
    FunctionsToExport = @(
        'New-PSUTaskManagerApp'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'windows', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.TaskManager'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

