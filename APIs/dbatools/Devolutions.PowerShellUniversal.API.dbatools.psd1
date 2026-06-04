@{
    RootModule        = 'Devolutions.PowerShellUniversal.API.dbatools.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '38b68761-cb28-4027-9d1c-0a571aeb1a96'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
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
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/APIs/dbatools'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}

