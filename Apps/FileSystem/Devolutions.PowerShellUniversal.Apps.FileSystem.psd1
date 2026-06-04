@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.FileSystem.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '6f57a471-f7b5-4a44-b9b7-a62ca8b13d90'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'File System components for Apps.'
    FunctionsToExport = @(
        'New-UDFileSystemBrowser'
    )

    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'filesystem', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/FileSystem'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

