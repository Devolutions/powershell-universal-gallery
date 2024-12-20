@{
    RootModule        = 'PowerShellUniversal.Apps.FileSystem.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '872450da-951c-445f-874e-c5a559a975b8'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'File System components for Apps.'
    FunctionsToExport = @(
        'New-UDFileSystemBrowser'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'filesystem', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.FileSystem'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

