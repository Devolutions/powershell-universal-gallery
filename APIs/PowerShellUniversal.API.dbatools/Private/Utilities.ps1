function Get-DbaApiSqlInstance {
    <#
    .SYNOPSIS
    Returns a SQL instance configuration.
    
    .DESCRIPTION
    Returns a SQL instance configuration.
    
    .PARAMETER SqlInstance
    The name of the SQL instance from the configuration.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance
    )

    $Config = Import-DbaApiConfiguration
    $Instance = $Config.SqlInstances | Where-Object Name -eq $SqlInstance
    if ($null -eq $instance) {
        throw 'Unknown SQL instance'
    }

    $Instance
}

function Import-DbaApiConfiguration {
    <#
        @{
            SqlInstances = @(
                @{
                    "Name" = "Instance1"
                    "SqlInstance" = "Server=ADAMDESK2;Database=PSU;Trusted_Connection=True;TrustServerCertificate=True"
                    "Credential" = "DbCredential"
                }
            )
        }
    #>
    Import-PowerShellDataFile -Path (Join-Path $Repository "DbaApiConfig.psd1")
}