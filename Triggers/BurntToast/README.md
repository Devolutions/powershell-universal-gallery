# BurntToast Client Notification

This module provides a way to send BurntToast notifications to client machines from a PowerShell Universal server. It contains a set of scripts for sending notifications and connecting them to triggers. It also provides an install script to download and configure the PowerShell Universal Agent to accept BurntToast notification commands. Finally, it configures an event hub and published folder to facilitate the download and communication. 

## Requirements

- [BurntToast](https://www.powershellgallery.com/packages/BurntToast)
- [PowerShell Universal License](https://powershelluniversal.com/pricing)
- [Permissive Security](https://docs.powershelluniversal.com/config/module#integrated-mode)

## Configuration 

### Server

First, install this module in PowerShell Universal. Next, you will need to add the `install.ps1` and PowerShell Universal Agent ZIP file into the `BurntToast` folder. This folder should be in the PSU repository root. On a default installation, this folder will be `$Env:ProgramData\UniversalAutomation\Repository\BurntToast`. 

You will need to customize the `$PSUURL` value with the URL of your PowerShell Universal server.

```powershell
$BurntToastDir = Join-Path $ENV:ProgramData "UniversalAutomation\Repository\BurntToast"
New-Item $BurntToast -ItemType Directory -ErrorAction SilentlyContinue
Invoke-WebRequest 'https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/Triggers/BurntToast/install.ps1' -OutFile (Join-Path $BurntToastDir "install.ps1")
Invoke-WebRequest 'https://powershelluniversal.com/download/psu/win-x64/latest' -OutFile (Join-Path $BurntToastDir "PowerShellUniversal.zip")
```

### Client

From the client, you can invoke the `install.ps1` script. By hosting the `install.ps1` within the published folder, you will be able to direct users to run the following command (adjusted for your PowerShell Universal server URL).

```powershell
iex ((iwr "http://localhost:5000/burnttoast/install.ps1").Content)
```