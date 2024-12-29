function Invoke-PSUBTTrigger {
    <#
        .SYNOPSIS
        Sends a BurntToast notification during a PowerShell Universal Trigger

        .PARAMETER Job
        The job object for a job-based trigger.
    #>
    param(
        [Parameter(ParameterSetName = 'Job')]
        $Job
    )

    if ($Job) {
        Send-PSUBTNotification -User $Job.Identity.Name -Text "Job $($Job.Id) has completed with status $($Job.Status)"
    }
}

function Send-PSUBTNotification {
    <#
        .SYNOPSIS 
        Send a BurntToast notification from PowerShell Universal to a connected client event hub.

        .PARAMETER Computer
        The name of the computer to send the notification to.

        .PARAMETER User
        The user to send the notification to.

        .PARAMETER Text
        The text of the notification.
    #>
    param(
        [Parameter(ParameterSetName = 'Computer', Mandatory)]
        $Computer,
        [Parameter(ParameterSetName = 'User', Mandatory)]
        $User,
        [Parameter()]
        $Text
    )

    $Parameters = @{
        Text = $Text
    }

    if ($Computer) {
        Invoke-PSUCommand -Computer $Computer -Command "New-BurntToastNotification" @Parameters
    }
    else {
        $Connection = Get-PSUEventHubConnection -Active | Where-Object UserName -eq $User
        if (-not $Connection) {
            throw "Connection for user $User not found";
        }

        Invoke-PSUCommand -ConnectionId $Connection.Id -Command "New-BurntToastNotification" @Parameters
    }
}