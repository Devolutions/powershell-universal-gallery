function Find-PsuAppCommand {
    <#
    .DESCRIPTION
    Retrieves commands that are available in PowerShell Universal apps.
    #>
    param(
        [Parameter(HelpMessage = "The name of the command to retrieve. Wildcards are supported.")]
        $Name
    )

    Get-Command -Name $Name | Where-Object { $_.Name.Contains("-UD") } | Select-Object -Property Name, Description
}

function Find-PsuAppCommandParameter {
    <#
    .DESCRIPTION
    Retrieves parameters for a specified PowerShell Universal app command.
    #>
    param(
        [Parameter(Mandatory = $true, HelpMessage = "The name of the command to retrieve parameters for.")]
        $CommandName
    )

    Get-Help -Name $CommandName -Parameter *
}

function Get-PsuAppCommandExample {
    <#
    .DESCRIPTION
    Retrieves examples for a specified PowerShell Universal app command.
    #>
    param(
        [Parameter(Mandatory = $true, HelpMessage = "The name of the command to retrieve examples for.")]
        $CommandName
    )

    Get-Help -Name $CommandName -Examples
}

function Get-PsuAppInstructions {
    <#
    .DESCRIPTION
    Provides instructions on how to use the PowerShell Universal app commands.
    #>
    Get-Content -Path "$PSScriptRoot\instructions.apps.md"
}