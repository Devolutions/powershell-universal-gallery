$Cache:CPUUsage = [System.Collections.Generic.Stack[double]]::new()
$Cache:MemoryUsage = [System.Collections.Generic.Stack[double]]::new()
$Cache:NetworkUsage = [System.Collections.Generic.Stack[double]]::new()
$Cache:Disks = [System.Collections.Generic.List[PSCustomObject]]::new()

Get-Disk | ForEach-Object {
    $Disk = [PSCustomObject]@{
        Number       = $_.Number
        Name         = $_.FriendlyName
        Size         = $_.Size / 1GB
        Usage        = ([System.Collections.Generic.Stack[double]]::new())
        UsageHistory = @()
        System       = $_.IsSystem 
        BusType      = $_.BusType
    }

    $Cache:Disks.Add($Disk)
}

$Schedule = New-UDEndpointSchedule -Every 1 -Second
$CISchedule = New-UDEndpointSchedule -Every 1 -Minute

New-UDEndpoint -Schedule $CISchedule -Endpoint {
    $ProgressPreference = 'SilentlyContinue'
    $Cache:ComputerInfo = Get-ComputerInfo
}

New-UDEndpoint -Schedule $Schedule -Endpoint {
    $Cache:CPUUsage.Push((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue) | Out-Null
    $Cache:MemoryUsage.Push((Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue) | Out-Null
    $Cache:NetworkUsage.Push((get-counter "\Network Interface(*)\Bytes Total/sec").CounterSamples.CookedValue) | Out-Null

    if ($Cache:CPUUsage.Count -gt 60) {
        $Cache:CPUUsage.Pop() | Out-Null
    }

    $TimeBack = $Cache:CPUUsage.Count
    $Cache:CPUUsageHistory = $Cache:CPUUsage | ForEach-Object {
        [PSCustomObject]@{
            Timestamp = $TimeBack
            Value     = $_
        }
        $TimeBack--
    } | Sort-Object -Property Timestamp

    if ($Cache:MemoryUsage.Count -gt 60) {
        $Cache:MemoryUsage.Pop() | Out-Null
    }

    $TimeBack = $Cache:MemoryUsage.Count
    $Cache:MemoryUsageHistory = $Cache:MemoryUsage | ForEach-Object {
        [PSCustomObject]@{
            Timestamp = $TimeBack
            Value     = $_
        }
        $TimeBack--
    } | Sort-Object -Property Timestamp

    if ($Cache:NetworkUsage.Count -gt 60) {
        $Cache:NetworkUsage.Pop() | Out-Null
    }

    $TimeBack = $Cache:NetworkUsage.Count
    $Cache:NetworkUsageHistory = $Cache:NetworkUsage | ForEach-Object {
        [PSCustomObject]@{
            Timestamp = $TimeBack
            Value     = $_ / 1MB
        }
        $TimeBack--
    } | Sort-Object -Property Timestamp

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
}

$Navigation = @(
    New-UDListItem -Href '/processes' -Icon (New-UDIcon -Icon 'cubes') -Label 'Processes'
    New-UDListItem -Href '/users' -Icon (New-UDIcon -Icon 'users') -Label 'Users'
    New-UDListItem -Href '/performance' -Icon (New-UDIcon -Icon 'dashboard') -Label 'Performance'
    New-UDListItem -Href '/services' -Icon (New-UDIcon -Icon 'puzzlePiece') -Label 'Services'
)

New-UDApp -Title 'Task Manager' -Pages @(
    & "$PSScriptRoot\pages\processes.ps1"
    & "$PSScriptRoot\pages\users.ps1"
    & "$PSScriptRoot\pages\performance.ps1"
    & "$PSScriptRoot\pages\services.ps1"
) -Navigation $Navigation