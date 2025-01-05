# Server Monitoring API

This module provides APIs and Event Hubs to monitor external servers. It uses the PowerShell Universal Agent to perform data collection and sends the data back to the PSU server APIs. Data is the stored in the persistent cache can can be retrieved via the APIs.

The following data is collected: 

- CPU Usage
- Memory Usage
- Disk Usage
- Network Usage
- Computer Information (`Get-ComputerInfo`)

## Requirements 

- [PowerShell Universal License](https://powershelluniversal.com/pricing)
- [Permissive Cmdlet Security](https://docs.powershelluniversal.com/config/module#integrated-mode)

## Configuration

After installing this module in your environment, you will need to configure the PowerShell Universal Agent on the hosts you wish to monitor. You can download the MSI for the agent from the [Downloads page](https://powershelluniversal.com/downloads).

Next, create an `agent.json` file in `$ENV:ProgramData\PowerShellUniversal`. This file needs to contain the URL of the server and the `Monitoring` event hub. 

```json
{
    "Connections": [
        {
            "Url": "http://localhost:5000",
            "Hub": "Monitoring"
        }
    ]
}
```

Once connect, you can run the `Invoke-PSUServerDataCollection` script in PowerShell Universal. It will fan out to all connected agents and collect data from them. Data is then stored by computer name in the database. 

You can view the data using the following APIs.

```powershell
# Return a list of monitored computers
$Computers = Invoke-RestMethod -Uri http://localhost:5000/monitoring/computer

# Return the data for a specific computer
$Data = Invoke-RestMethod -Uri http://localhost:5000/monitoring/computer/$($Computers[0].Name)
```

You can also return the collection data within PSU using `Get-PSUCache`.

```powershell
# Return all monitoring data
Get-PSUCache -List | Where-Object { $_.Key -like 'Monitoring_*' } | ForEach-Object { Get-PSUCache -Key $_.Key }

# Return monitoring data for a specific computer
Get-PSUCache -Key "Monitoring_$($Computers[0].Name)"
```

## Scheduling 

The `Invoke-PSUServerDataCollection` script can be scheduled to run on a regular basis to collect data from the agents. You can use the `New-PSUSchedule` cmdlet to create a schedule that runs the script or do so in the admin console. 

```powershell
New-PSUSchedule -Script "PowerShellUniversal.API.Monitor\Invoke-PSUServerDataCollection" -Cron '0 0 * * *'
```