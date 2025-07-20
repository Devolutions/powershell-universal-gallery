New-UDPage -Name "Accounts" -Icon (New-UDIcon -Icon 'Building' -Style @{ marginRight = "16px"}) -Content {
    New-CRMNewAccountButton

    New-UDLayout -Columns 3 -Content {
        New-UDCard -Title "Active Accounts" -Content {
            New-UDTypography -Text "10" -Variant h4
        }
        New-UDCard -Title "Stale Accounts" -Content {
            New-UDTypography -Text "10" -Variant h4
        }
        New-UDCard -Title "Waiting Response" -Content {
            New-UDTypography -Text "10" -Variant h4
        }
    }


    New-UDTable -LoadRows {
        $Data = Get-CRMAccount

        foreach ($Filter in $EventData.Filters) {
            $Data = $Data | Where-Object -Property $Filter.Id -Match -Value $Filter.Value
        }
        $TotalCount = $Data.Count
        if (-not [string]::IsNullOrEmpty($EventData.OrderBy.Field)) {
            $Descending = $EventData.OrderDirection -ne 'asc'
            $Data = $Data | Sort-Object -Property ($EventData.orderBy.Field) -Descending:$Descending
        }
        $Data = $Data | Select-Object -First $EventData.PageSize -Skip ($EventData.Page * $EventData.PageSize)
        $Data | Out-UDTableData -Page $EventData.Page -TotalCount $TotalCount -Properties $EventData.Properties 
    } -Columns @(
        New-UDTableColumn -Property "Name" -Title "Name"
        New-UDTableColumn -Property "Created" -Title "Created" -OnRender {
            New-UDDateTime -InputObject $EventData.Created
        }
        New-UDTableColumn -Property "CreatedBy" -Title "Created by"
        New-UDTableColumn -Property "LastInteraction" -Title "Last Interaction" -OnRender {
            New-UDDateTime -InputObject $EventData.LastInteraction
        }
        New-UDTableColumn -Property "Actions" -Title "Actions" -OnRender {
            $AccountName = $EventData.Name

            New-UDButton -Icon (New-UDIcon -Icon "Eye") -OnClick {
                Invoke-UDRedirect -Url "/account/$AccountName"
            } -Color info -Text View

            New-UDButton -Icon (New-UDIcon -Icon "Trash") -OnClick {
                Remove-CRMAccount -Name $AccountName
                Show-UDToast -Message "Deleted $AccountName"
                Sync-UDElement -Id 'accounts'
            } -Color error -Text Delete
        }
    ) -Id 'accounts' -Dense -ShowSearch -ShowFilter -ShowPagination -ShowRefresh -ShowSort
} -AutoInclude -DefaultHomePage