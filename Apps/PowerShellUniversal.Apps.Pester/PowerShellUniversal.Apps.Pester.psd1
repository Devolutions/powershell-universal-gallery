@{
    RootModule        = 'PowerShellUniversal.Apps.Pester.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'db3d05c0-15ba-4fe2-8122-138c77c3f813'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
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
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.Pester'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

