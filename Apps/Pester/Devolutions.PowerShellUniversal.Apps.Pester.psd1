@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.Pester.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '69404a23-2f0d-49dd-8b02-e95ca25e7f19'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'A Pester test result viewer for PowerShell Universal.'
    FunctionsToExport = @(
        'New-UDPesterApp',
        'Invoke-PSUPesterTest'
    )
    RequiredModules   = @('Pester')
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', "PowerShellUniversal", 'Pester')
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Pester'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

