# [dbatools](https://docs.dbatools.io/) HTTP REST API

This API is a REST API for [dbatools](https://docs.dbatools.io/). It is built on top of PowerShell Universal and provides a way to interact with dbatools using HTTP requests.

## Usage

Installing this module in your PowerShell Universal environment will expose the API at the `/api/dbatools` endpoints. Once installed and configured, you will be able to interact with the API using HTTP requests.

## Configuration

To use this API, you will need to create a `PSD1` file in the root for the PowerShell Universal repository named `DbaApiConfig.psd1`. This file should contain the following configuration:

```powershell
@{
    SqlInstances = @(
        @{
            Name = 'Name of SQL Instance'
            ServerInstance = 'Connection String'
            Credential = 'Optional credential variable to use'
        }
    }
}
```

## Endpoints

### Databases

#### `GET|/api/dbatools/:sqlinstance/database`
Returns a list of databases on the specified SQL instance.

- Required Role: `dbatools Administrator` or `Administrator`
- Underlying Command: [`Get-DbaDatabase`](https://docs.dbatools.io/Get-DbaDatabase)

#### `GET|/api/dbatools/:sqlinstance/database/:database/schema`
Finds the database schema SMO object(s) based on the given filter params.

- Required Role: `dbatools Administrator` or `Administrator`
- Underlying Command: [`Get-DbaDbSchema`](https://docs.dbatools.io/Get-DbaDbSchema)

#### `GET|/api/dbatools/:sqlinstance/database/:database/space`
Returns the space used by the specified database.

- Required Role: `dbatools Administrator` or `Administrator`
- Underlying Command: [`Get-DbaDbSpace`](https://docs.dbatools.io/Get-DbaDbSpace)

#### `GET|/api/dbatools/:sqlinstance/database/:database/state`
Gets various options for databases, hereby called "states"

- Required Role: `dbatools Administrator` or `Administrator`
- Underlying Command: [`Get-DbaDbState`](https://docs.dbatools.io/Get-DbaDbState)

#### `GET|/api/dbatools/:sqlinstance/database/:database/storedprocedure`
Gets database Stored Procedures

- Required Role: `dbatools Administrator` or `Administrator`
- Underlying Command: [`Get-DbaDbStoredProcedure`](https://docs.dbatools.io/Get-DbaDbStoredProcedure)

### Utilities

#### `POST|/api/dbatools/:sqlinstance/database/:database/query`
Executes a query against the specified database.

- Required Role: `dbatools Administrator` or `Administrator`
- Underlying Command: [`Invoke-DbaQuery`](https://docs.dbatools.io/Invoke-DbaQuery)

## Roles

### dbatools Administrator

This role can use all of the dbatools commands.
