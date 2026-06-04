Import-Module "$PSScriptRoot\Devolutions.PowerShellUniversal.Apps.Tools.psd1" -Force

# Create a new Project
New-UDReactComponent -Name "react-icons" -Path "$PSScriptRoot\project"

# Node Libraries to Install
$Libraries = @("react-icons")

$Libraries | ForEach-Object {
    Add-UDReactComponentLibrary -Name $_ -Path "$PSScriptRoot\project"
}

# Build the React Component
Invoke-UDReactComponentBuild -Path "$PSScriptRoot\project" -OutputPath "$PSScriptRoot\output" -Force