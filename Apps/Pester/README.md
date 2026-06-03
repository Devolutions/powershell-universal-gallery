# Pester Test Viewer App

This app provides a UI for viewing Pester tests results.

![Pester Test Results Dashboard](https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/images/Apps/Pester.png)

## Requirements

- [Pester v5+](https://pester.dev/)
- [PowerShell Universal v5.2+](https://powershelluniversal.com/downloads)
- [Integrated Cmdlet Security](https://docs.powershelluniversal.com/config/module#integrated-mode)

## Configuration

This module does not require any configuration. It does expect that Pester test results are stored in the `$Repository\TestResults` folder. This module includes `Invoke-PSUPesterTest` which will run Pester tests and store the results in the correct location.