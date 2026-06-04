@{
    RootModule        = 'Devolutions.PowerShellUniversal.Triggers.BurntToast.psm1'
    Description       = "Send BurntToast notifications from PowerShell Universal to client machines."
    ModuleVersion     = "1.0.0"
    Author            = 'Devolutions, Inc.'
    Copyright         = "Ironman Software"
    GUID              = "30fa0fc5-de8d-4f20-8bbf-8ec79d961f3b"
    FunctionsToExport = @('Send-PSUBTNotification', 'Invoke-PSUBTTrigger')
    RequiredModules   = @('BurntToast')
    PrivateData       = @{
        PSData = @{
            Tags       = @('trigger', "PowerShellUniversal", 'BurntToast', 'windows')
            LicenseUri = 'https://github.com/devolutions/powershell-universal-gallery/blob/main/LICENSE'
            ProjectUri = 'https://github.com/devolutions/powershell-universal-gallery/tree/main/Triggers/BurntToast'
            IconUri    = 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/script.png'
        }
    }
}