New-UDPage -Url "/contact/:emailAddress" -Name "Contact" -Content {
    $Account = Get-CRMContact -EmailAddress $EmailAddress

    $Data = @(
        [PSCustomObject]@{ Name = "Name"; Value = $Account.Name }
        [PSCustomObject]@{ Name = "Created"; Value = $Account.Created }
        [PSCustomObject]@{ Name = "LastInteraction"; Value = $Account.LastInteraction }
        [PSCustomObject]@{ Name = "CreatedBy"; Value = $Account.CreatedBy }
    )

    New-UDTable -Data $Data -Columns @(
        New-UDTableColumn -Property Name -Title Name
        New-UDTableColumn -Property Value -Title Value -OnRender {
            if ($EventData.Name -eq 'Created' -or $EventData.Name -eq 'LastInteraction' )
            {
                New-UDDateTime -InputObject $EventData.Value
            }
            else
            {
                $EventData.Value
            }
        }
    )
} -AutoInclude