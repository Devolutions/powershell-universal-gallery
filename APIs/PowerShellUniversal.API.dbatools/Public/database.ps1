function Get-DbaApiDatabase {
    <#
    .SYNOPSIS
    Returns a list of databases for a given SQL instance.
    
    .DESCRIPTION
    Returns a list of databases for a given SQL instance.
    
    .PARAMETER SqlInstance
    The SQL instance to query.

    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database'

    Returns a list of databases for the SQL instance named Instance1.

    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database?Database=master'

    Returns a list of databases for the SQL instance named Instance1 where the database name is master.
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

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    if ($Query.Database) {
        $Parameters.Database = $Query.Database
    }

    Get-DbaDatabase @Parameters | ForEach-Object {
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

function Get-DbaApiDbSpace {
    <#
    .SYNOPSIS
    Returns database file space information for database files on a SQL instance.
    
    .DESCRIPTION
    Returns database file space information for database files on a SQL instance.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/master/space'
    
    Returns database file space information for the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter(Mandatory)]
        $Database
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Database    = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    Get-DbaDbSpace @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            Name         = $_.Name
            SizeMB       = $_.SizeMB
            UsedMB       = $_.UsedMB
            FreeMB       = $_.FreeMB
            PercentUsed  = $_.PercentUsed
            AutoGrowth   = $_.AutoGrowth
            DataFiles    = $_.DataFiles
            LogFiles     = $_.LogFiles
        }
    }
}

function Get-DbaApiDbState {
    <#
    .SYNOPSIS
    Returns the state of a database.
    
    .DESCRIPTION
    Returns the state of a database.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/master/state'
    
    Returns the state of the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter(Mandatory)]
        $Database
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Database    = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    Get-DbaDbState @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            State        = $_.State
        }
    }
}

function Get-DbaApiDbSchema {
    <#
    .SYNOPSIS
    Returns the schema of a database.
    
    .DESCRIPTION
    Returns the schema of a database.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/master/schema'
    
    Returns the schema of the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter(Mandatory)]
        $Database
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Database    = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    Get-DbaDbSchema @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            Schema       = $_.Schema
        }
    }
}

function Get-DbaApiDbTable {
    <#
    .SYNOPSIS
    Returns the tables of a database.
    
    .DESCRIPTION
    Returns the tables of a database.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/master/table'
    
    Returns the tables of the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter(Mandatory)]
        $Database,
        [Parameter()]
        $Table
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Database    = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    if ($Table) {
        $Parameters.Table = $Table
    }

    Get-DbaDbTable @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            Schema       = $_.Schema
            Name         = $_.Name
            Created      = $_.Created
            Modified     = $_.Modified
            Rows         = $_.Rows
            DataSpace    = $_.DataSpace
            IndexSpace   = $_.IndexSpace
            UnusedSpace  = $_.UnusedSpace
        }
    }
}

function Get-DbaApiDbStoredProcedure {
    <#
    .SYNOPSIS
    Returns the stored procedures of a database.
    
    .DESCRIPTION
    Returns the stored procedures of a database.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/master/storedprocedure'
    
    Returns the stored procedures of the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter(Mandatory)]
        $Database,
        [Parameter()]
        $Name
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Database    = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    if ($Name) {
        $Parameters.Name = $Name
    }

    Get-DbaDbStoredProcedure @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            Schema       = $_.Schema
            Name         = $_.Name
            Created      = $_.Created
            Modified     = $_.Modified
            Definition   = $_.Definition
        }
    }
}

function Get-PSUDbaApiDbView {
    <#
    .SYNOPSIS
    Returns the views of a database.
    
    .DESCRIPTION
    Returns the views of a database.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/master/view'
    
    Returns the views of the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter(Mandatory)]
        $Database,
        [Parameter()]
        $Name
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
        Database    = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    if ($Name) {
        $Parameters.Name = $Name
    }

    Get-DbaDbView @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            Schema       = $_.Schema
            Name         = $_.Name
            Created      = $_.Created
            Modified     = $_.Modified
            Definition   = $_.Definition
        }
    }
}

function Get-DbaApiDbMemoryUsage {
    <#
    .SYNOPSIS
    Returns the memory usage of a database.
    
    .DESCRIPTION
    Returns the memory usage of a database.
    
    .PARAMETER SqlInstance
    The SQL instance to query.
    
    .PARAMETER Database
    The database to query.
    
    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/memoryusage'
    
    Returns the memory usage of the SQL instance named Instance1.

    .EXAMPLE
    PS > Invoke-RestMethod -Uri 'http://localhost:5000/api/dbatools/Instance1/database/memoryusage?Database=master'
    
    Returns the memory usage of the master database on the SQL instance named Instance1.
    #>
    param(
        [Parameter(Mandatory)]
        $SqlInstance,
        [Parameter()]
        $Database
    )

    try {
        $Instance = Get-DbaApiSqlInstance -SqlInstance $SqlInstance
    }
    catch {
        New-PSUApiResponse -StatusCode 404
    }

    $Parameters = @{
        SqlInstance = $Instance.SqlInstance
    }

    if ($Database) {
        $Parameters.Database = $Database
    }

    if ($Instance.Credential) {
        $Parameters.SqlCredential = Get-Item "Secret:\$($Instance.Credential)"
    }

    Get-DbaDbMemoryUsage @Parameters | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            SqlInstance  = $_.SqlInstance
            Database     = $_.Database
            BufferPool   = $_.BufferPool
            PlanCache    = $_.PlanCache
            ColumnStore  = $_.ColumnStore
            InMemory     = $_.InMemory
        }
    }
}