<#
    This script is used to download, 
    configure and start a 
    PowerShell Universal agent that 
    can be used to receive BurntToast
    notifications from a PSU server.

    This script is part of a PowerShell Universal extension module that
    provides a published folder to host this script alongside the
    PowerShell Universal Agent binaries.

    Below is an example command you can run to run this script.

    iex ((iwr "http://localhost:5000/burnttoast/install.ps1").Content)
#>

$PSUURL = "http://localhost:5000"

# Install BurntToast
$Module = Get-Module -ListAvailable -Name 'BurntToast'
if (-not $Module) {
    Install-Module 'BurntToast' -Scope CurrentUser -Force
}

# Set up the agent
$PSUDirectory = Join-Path $ENV:APPDATA "PowerShellUniversal"
if (-not (Test-Path $PSUDirectory)) {
    New-Item $PSUDirectory -ItemType Directory
}

$AgentConfigPath = Join-Path $PSUDirectory "agent.json"

Out-File -FilePath $AgentConfigPath -InputObject (@{
        Connections = @(
            @{
                Url = "$PSUURL"
                Hub = "BurntToast"
            }
        )
    } | ConvertTo-Json)

# Download the agent
$OutputZip = Join-Path $ENV:TMP "PowerShellUniversal.zip"
Invoke-WebRequest "$PSUURL\BurntToast\PowerShellUniversal.zip" -OutFile $OutputZip

$AgentFolder = Join-Path $ENV:USERPROFILE ".psuagent"

if (-not (Test-Path $AgentFolder)) {
    New-Item $AgentFolder -ItemType Directory
}

Expand-Archive -Path $OutputZip -DestinationPath $AgentFolder

Start-Process (Join-Path $AgentFolder "psuagent.exe")

# todo: setup to run on login

# cleanup
Remove-Item $OutputZip
