
function Invoke-PSUServerDataCollection {
    <#
    .SYNOPSIS
    Collects server data and sends it to the monitoring API.
    
    .DESCRIPTION
    This command collects server data and sends it to the monitoring API.
    #>
    $CollectionScript = {
        foreach ($disk in $Cache:Disks) {
            $wmi = Get-CimInstance -Class "Win32_PerfFormattedData_PerfDisk_PhysicalDisk" -Filter "Name LIKE '$($Disk.Number)%'"
            $Disk.Usage.Push(($wmi.PercentDiskTime)) | Out-Null
    
            if ($Disk.Usage.Count -gt 60) {
                $Disk.Usage.Pop() | Out-Null
            }
    
            $TimeBack = $Disk.Usage.Count
            $Disk.UsageHistory = $Disk.Usage | ForEach-Object {
                [PSCustomObject]@{
                    Timestamp = $TimeBack
                    Value     = $_
                }
                $TimeBack--
            } | Sort-Object -Property Timestamp
        }
    
        $Disks = @()
        Get-Disk | ForEach-Object {
    
            $wmi = Get-CimInstance -Class "Win32_PerfFormattedData_PerfDisk_PhysicalDisk" -Filter "Name LIKE '$($Disk.Number)%'"
    
            $Disk = [PSCustomObject]@{
                Number                 = $_.Number
                Name                   = $_.FriendlyName
                Size                   = $_.Size / 1GB
                PercentDiskTime        = $wmi.PercentDiskTime
                BytesPerSec            = $wmi.DiskBytesPersec
                PercentIdleTime        = $wmi.PercentIdleTime
                CurrentDiskQueueLength = $wmi.CurrentDiskQueueLength
                System                 = $_.IsSystem 
                BusType                = $_.BusType
            }
    
    
            $Disks += $Disk
        }
    
        $Payload = [PSCustomObject]@{
            MachineName  = [Environment]::MachineName
            Timestamp    = [DateTime]::UtcNow
            CPUUsage     = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
            MemoryUsage  = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
            NetworkUsage = (Get-Counter "\Network Interface(*)\Bytes Total/sec").CounterSamples.CookedValue
            ComputerInfo = Get-ComputerInfo
        }
    
        $RequestBody = [System.Management.Automation.PSSerializer]::Serialize($Payload)
    
        Invoke-RestMethod "<SERVERURL>/monitoring/consume" -ContentType 'text/plain' -Body $RequestBody -Method POST
    }.ToString() -replace "<SERVERURL>", $PSU_INTEGRATED_API_URL
    
    
    Invoke-PSUCommand -Command 'Invoke-Expression' -Hub 'Monitoring' -Parameters @{
        Command = $CollectionScript
    }
}

