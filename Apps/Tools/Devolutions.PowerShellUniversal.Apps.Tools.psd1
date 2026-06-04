@{
    RootModule        = 'Devolutions.PowerShellUniversal.Apps.Tools.psm1'
    ModuleVersion     = '1.1.0'
    GUID              = '6d700aa6-6e4e-45b2-ab28-2ee823ccdbb7'
    Author            = 'Devolutions, Inc.'
    CompanyName       = 'Devolutions, Inc.'
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
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Apps/Tools'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}

