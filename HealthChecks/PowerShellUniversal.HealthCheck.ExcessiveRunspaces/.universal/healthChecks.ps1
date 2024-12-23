New-PSUHealthCheck -Name "Excessive Runspace Usage" -Description "Check if the server is using an excessive amount of runspaces." -ScriptBlock {
    if (-not $PSUExcessiveRunspaceCount) {
        $PSUExcessiveRunspaceCount = 50
    }

    $Runspaces = Get-Runspace
    if ($Runspaces.Count -gt $PSUExcessiveRunspaceCount) {
        New-PSUHealthCheckResult -Level Error -Message "The server is using an excessive amount of runspaces. ($($Runspaces.Count))"
        return 
    }

    New-PSUHealthCheckResult -Level Ok -Message "The server is using a reasonable amount of runspaces."
}