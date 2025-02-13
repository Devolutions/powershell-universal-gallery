function Send-PSUBlueskyPost {
    param($Message)

    Start-BskySession -credential $Secret:PSUBlueskyCredential | Out-Null

    $param = @{
        Message   = $Message
    }

    New-BskyPost @param
}

function Get-PSUBlueskyFeed {
    Start-BskySession -credential $Secret:PSUBlueskyCredential | Out-Null
    Get-BskyFeed
}

function New-PSUBlueskyFeedTable {
    $Data = Get-PSUBlueskyFeed | Select-Object Text, AuthorDisplay, Url, Date

    New-UDTable -Columns @(
        New-UDTableColumn -Property 'Text'
        New-UDTableColumn -Property 'AuthorDisplay'
        New-UDTableColumn -Property 'Date'
        New-UDTableColumn -Property 'Url' -Title "View" -OnRender {
            New-UDButton -Text 'View' -OnClick {
                Invoke-UDRedirect -Url $EventData.Url -OpenInNewWindow
            }
        }
    ) -Data $Data
}