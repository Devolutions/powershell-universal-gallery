@{
    RootModule = 'PowerShellUniversal.McpTools.psm1'
    ModuleVersion = '1.0.0'
    GUID = '6d41be3b-7147-40d7-988f-b74ffb7a9829'
    Author = 'Adam Driscoll'
    CompanyName = 'Devolutions'
    Copyright = '(c) Devolutions, Inc. All rights reserved.'
    FunctionsToExport = @(
        'Find-PsuAppCommand',
        'Find-PsuAppCommandParameter',
        'Get-PsuAppCommandExample',
        'Get-PsuAppInstructions'
    )
    PrivateData = @{
        PSData = @{
            Tags = 'PowerShellUniversal'
        }
    } 
}

