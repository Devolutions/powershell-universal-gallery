# database
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDatabase' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/memoryusage' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbMemoryUsage' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/space' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbSpace' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/state' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbState' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/table' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbTable' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/view' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbView' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'

# utilities
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/query' -Module 'Devolutions.PowerShellUniversal.API.dbatools' -Command 'Invoke-DbaApiQuery' -Authentication -Role @("dbatools Administrator", "Administrator") -Method 'POST' -Documentation 'dbatools'