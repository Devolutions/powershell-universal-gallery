# dbatools HTTP REST API

This API is a REST API for dbatools. It is built on top of PowerShell Universal and provides a way to interact with dbatools using HTTP requests.

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

## Roles

### dbatools Administrator

This role can use all of the dbatools commands.
