function Invoke-DbaApiQuery {
    <#
    .SYNOPSIS
    A command to run explicit T-SQL commands or files.
    
    .DESCRIPTION
    This function is a wrapper command around Invoke-DbaAsync, which in turn is based on Invoke-SqlCmd2.
    
    .PARAMETER SqlQuery
    The T-SQL query to run.
    
    .PARAMETER ServerInstance
    The server instance to run the query against.
    
    .PARAMETER Database
    The database to run the query against.
    
    .PARAMETER SqlParameters
    A hashtable of parameters to pass to the query.
    
    .EXAMPLE
    PS> Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database1/query' -Method Post -Body (@{ SqlQuery = 'SELECT * FROM sys.databases' } | ConvertTo-Json) -ContentType 'application/json'
    
    Executes the query against the specified database.
     
    #>
    param(
        [Parameter(Mandatory)]
        [string]$SqlQuery,
        [Parameter(Mandatory)]
        [string]$ServerInstance,
        [Parameter(Mandatory)]
        [string]$Database,
        [Parameter()]
        [Hashtable]$SqlParameters
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Query       = $SqlQuery
    }

    if ($Database) {
        $Parameters.Database = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    if ($SqlParameters) {
        $Parameters.SqlParameter = $SqlParameters
    }

    Invoke-DbaQuery @Parameters

}