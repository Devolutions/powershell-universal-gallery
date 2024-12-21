# PSResourceGet API

This module provides a PowerShell Universal API for managed PowerShell resources. It uses `Microsoft.PowerShell.PSResourceGet` to find, install and remove PowerShell modules.

## Endpoints 

- `GET /psresourceget/module` - Get a list of modules
- `GET /psresourceget/module/{name}` - Find a module by name.
- `POST /psresourceget/module` - Install a module.
- `DELETE /psresourceget/module/{name}` - Uninstall a module.
- `GET /psresourceget/repository` - Get a list of repositories.
- `POST /psresourceget/repository` - Register a new repository.