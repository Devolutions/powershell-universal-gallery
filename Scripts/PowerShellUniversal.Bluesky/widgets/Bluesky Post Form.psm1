class BlueskyPost {
    [string]$Message
}

$Variables["Model"] = [BlueskyPost]::new()

function Submit {
    param($EventArgs)

    Invoke-PSUScript -Name 'PowerShellUniversal.Bluesky\Send-PSUBlueskyPost' -Message $EventArgs.Model.Message
}