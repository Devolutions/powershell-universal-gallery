@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.TaskManager.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'e8743cc2-c33f-415b-a517-6a5c0d4d84b1'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Task Manager for PowerShell Universal.'
    FunctionsToExport = @(
        'New-PSUTaskManagerApp'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'windows', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/TaskManager'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

