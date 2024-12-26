function Get-DbaApiDatabase {
    <#
    .SYNOPSIS
    Returns a list of databases for a given SQL instance.
    
    .DESCRIPTION
    Returns a list of databases for a given SQL instance.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    Get-DbaDatabase -SqlInstance $Instance | ForEach-Object {
        [PSCustomObject]@{
            ComputerName  = $_.ComputerName
            Name          = $_.Name
            MSSQLSERVER   = $_.MSSQLSERVER
            SqlInstance   = $_.SqlInstance
            Status        = $_.Status
            SizeMB        = $_.SizeMB
            Collation     = $_.Collation
            Compatibility = $_.Compatibility
            Owner         = $_.Owner
        }
    }
}

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

    $Instance.ConnectionString
}

function Import-DbaApiConfiguration {
    <#
        @{
            SqlInstances = @(
                @{
                    "Name" = "Instance1"
                    "ConnectionString" = "Server=ADAMDESK2;Database=PSU;Trusted_Connection=True;TrustServerCertificate=True"
                }
            )
        }
    #>
    Import-PowerShellDataFile -Path (Join-Path $Repository "DbaApiConfig.psd1")
}