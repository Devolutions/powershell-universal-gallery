# database
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database' -Module 'PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDatabase' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/memoryusage' -Module 'PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbMemoryUsage' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/space' -Module 'PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbSpace' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/state' -Module 'PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbState' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/table' -Module 'PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbTable' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/view' -Module 'PowerShellUniversal.API.dbatools' -Command 'Get-DbaApiDbView' -Authentication -Role @("dbatools Administrator", "Administrator") -Documentation 'dbatools'

# utilities
New-PSUEndpoint -Url '/api/dbatools/:sqlinstance/database/:database/query' -Module 'PowerShellUniversal.API.dbatools' -Command 'Invoke-DbaApiQuery' -Authentication -Role @("dbatools Administrator", "Administrator") -Method 'POST' -Documentation 'dbatools'