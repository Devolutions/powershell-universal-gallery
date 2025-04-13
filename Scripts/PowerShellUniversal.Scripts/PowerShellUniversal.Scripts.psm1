function Format-PSUJobDescription {
    <#
    .SYNOPSIS
    Creates a description of a job 
    
    .DESCRIPTION
    Creates a description of a job 
    
    .PARAMETER Job
    The job to describe
    
    .EXAMPLE
    Format-PSUJobDescription -Job $Job
    #>
    param (
        [Parameter(Mandatory = $true)]
        $Job,
        [Parameter()]
        [switch]$Markdown

    )

    if ($Job.Triggered) {
        $Text = "The job was triggered by **$($Job.Trigger)**"
    }
    elseif ($Job.ScheduleId -ne 0 -and $Job.ScheduleId -ne $null) {
        if ($Markdown) {
            $Text = "The job ran on the schedule [$($Job.Schedule)]($ApiUrl/admin/automation/schedules)"
        }
        else {
            $Text = "The job ran on the schedule <$ApiUrl/admin/automation/schedules|$($Job.Schedule)>"
        }
    }
    else {
        $Text = "The job was run manually by $($Job.Identity.Name)"
    }

    if ($Job.Environment -ne $Null) {
        $Text += " in the $($Job.Environment) environment"
    }

    if ($Job.Credential -ne $null) {
        $Text += " as $($Job.Credential)"
    }

    if ($Job.ComputerName -ne $null) {
        $Text += " on $($Job.ComputerName)"
    }

    $Text
}