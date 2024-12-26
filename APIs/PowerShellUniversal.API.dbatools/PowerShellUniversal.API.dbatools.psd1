@{
    RootModule        = 'PowerShellUniversal.API.dbatools.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd166078f-c0ae-4395-9331-9a38a5886688'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'HTTP REST APIs for dbatools.'
    RequiredModules   = @('dbatools')
    FunctionsToExport = @(
        'Get-DbaApiDatabase',
        'Get-DbaApiSqlInstance',
        'Import-DbaApiConfiguration',
        'Get-DbaApiDbMemoryUsage',
        'Get-DbaApiDbSpace',
        'Get-DbaApiDbState',
        'Get-DbaApiDbTable',
        'Get-DbaApiDbView',
        'Invoke-DbaApiQuery'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @('PowerShellUniversal', 'api', 'dbatools')
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/APIs/PowerShellUniversal.API.dbatools'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}

