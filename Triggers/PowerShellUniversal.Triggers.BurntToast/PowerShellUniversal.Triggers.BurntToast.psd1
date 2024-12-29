@{
    RootModule        = 'PowerShellUniversal.Triggers.BurntToast.psm1'
    Description       = "Send BurntToast notifications from PowerShell Universal to client machines."
    ModuleVersion     = "1.0.0"
    Author            = "Ironman Software"
    Copyright         = "Ironman Software"
    Company           = "Ironman Software"
    GUID              = "30fa0fc5-de8d-4f20-8bbf-8ec79d961f3b"
    FunctionsToExport = @('Send-PSUBTNotification', 'Invoke-PSUBTTrigger')
    RequiredModules   = @('BurntToast')
    PrivateData       = @{
        PSData = @{
            Tags       = @('trigger', "PowerShellUniversal", 'BurntToast', 'windows')
            LicenseUri = 'https://github.com/ironmansoftware/scripts/blob/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Triggers/PowerShellUniversal.Triggers.BurntToast'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}