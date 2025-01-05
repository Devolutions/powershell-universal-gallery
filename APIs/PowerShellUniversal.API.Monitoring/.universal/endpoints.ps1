New-PSUEndpoint -Url "/monitoring/computer" -Description "Returns a list of monitored computers. " -Method @('GET') -Endpoint {
    Get-PSUCache -List | Where-Object { $_.Key.StartsWith("Monitoring_") } | ForEach-Object {
        $_.Key -split '_' | Select-Object -Last 1
    }
} 
New-PSUEndpoint -Url "/monitoring/computer/:computer" -Description "Returns monitoring information for a computer. " -Method @('GET') -Endpoint {
    param($Computer)

    Get-PSUCache -Key "Monitoring_$Computer" -Integrated
} 
New-PSUEndpoint -Url "/monitoring/consume" -Description "Consumes data sent from client machines. " -Method @('POST') -Endpoint {
    $Payload = [System.Management.Automation.PSSerializer]::Deserialize($Body)
    Set-PSUCache -Key "Monitoring_$($Payload.MachineName)" -Value $Payload -Persist
}