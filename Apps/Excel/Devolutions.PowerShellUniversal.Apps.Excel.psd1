@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.Excel.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '7b9485e0-cb4f-4e1b-bad3-151e3c26a64c'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
    Copyright         = '(c) Devolutions, Inc. All rights reserved.'
    Description       = 'Excel components for Apps.'
    FunctionsToExport = @(
        'New-UDExcelTable'
    )
    RequiredModules   = @("ImportExcel")
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'excel', 'office', "PowerShellUniversal")
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Excel'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        } 
    } 
}

