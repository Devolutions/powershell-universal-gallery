@{
    RootModule        = 'PowerShellUniversal.Apps.Excel.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '35996055-dfb8-4641-82dd-6be177f7e292'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Excel components for Apps.'
    FunctionsToExport = @(
        'New-UDExcelTable'
    )
    RequiredModules   = @("ImportExcel")
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'excel', 'office', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShellUniversal.Apps.Excel'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        } 
    } 
}

