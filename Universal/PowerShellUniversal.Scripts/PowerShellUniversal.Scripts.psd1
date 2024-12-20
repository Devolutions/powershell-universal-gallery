@{
    RootModule        = 'PowerShellUniversal.Scripts.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '06236701-c52a-4f75-9d8d-5f239d3862e2'
    Author            = 'Ironman Software'
    CompanyName       = 'Ironman Software'
    Copyright         = '(c) Ironman Software. All rights reserved.'
    Description       = 'A collection of scripts for PowerShell Universal.'
    FunctionsToExport = @('Format-PSUJobDescription')
    PrivateData       = @{
        PSData = @{
            Tags       = @('script', "PowerShellUniversal")
            LicenseUri = 'https://github.com/ironmansoftware/scripts/tree/main/LICENSE'
            ProjectUri = 'https://github.com/ironmansoftware/scripts/tree/main/Universal/PowerShellUniversal.Scripts'
            IconUri    = 'https://raw.githubusercontent.com/ironmansoftware/scripts/main/images/script.png'
        }
    }
}