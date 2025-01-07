@{
    RootModule        = 'PowerShellUniversal.Apps.Tools.psm1'
    ModuleVersion     = '1.1.0'
    GUID              = '208e8828-3397-4a3e-ad9d-859866060cc8'
    Author            = 'Ironman Software, LLC'
    CompanyName       = 'Ironman Software, LLC'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'Tools for working with PowerShell apps.'
    FunctionsToExport = @(
        'New-UDCenter', 
        'New-UDRight', 
        'New-UDConfirm', 
        'New-UDLineBreak', 
        'Show-UDEventData', 
        'Reset-UDPage', 
        'Show-UDObject', 
        'Get-UDCache', 
        'Show-UDVariable', 
        'Show-UDThemeColorViewer', 
        'ConvertTo-UDJson',
        'New-UDReactComponent',
        'Add-UDReactComponentLibrary',
        'Invoke-UDReactComponentBuild'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @('app', 'PowerShellUniversal')
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Apps/PowerShell/Tools'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/app.png'
        }
    }
}

