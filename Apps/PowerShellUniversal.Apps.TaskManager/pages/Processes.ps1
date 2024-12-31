New-UDPage -Url "/processes" -Name "Processes" -Content {
    New-UDTable -LoadRows {
        $Rows = Get-Process | ForEach-Object {
            [PSCustomObject]@{
                Name   = $_.Name
                Pid    = $_.Id
                Cpu    = $_.CPU
                Memory = $_.PrivateMemorySize / 1MB
            }
        }

        foreach ($Filter in $EventData.Filters) {
            $Rows = $Rows | Where-Object -Property $Filter.Id -Match -Value $Filter.Value
        }

        $Rows = $Rows | Where-Object { $_.Name -match $EventData.search -or $_.Pid -eq $EventData.Search }

        $TotalCount = $Rows.Count

        if (-not [string]::IsNullOrEmpty($EventData.OrderBy.Field)) {
            $Descending = $EventData.OrderDirection -ne 'asc'
            $Rows = $Rows | Sort-Object -Property ($EventData.orderBy.Field) -Descending:$Descending
        }

        $Rows = $Rows | Select-Object -First $EventData.PageSize -Skip ($EventData.Page * $EventData.PageSize)

        $Rows | Out-UDTableData -Page $EventData.Page -TotalCount $TotalCount -Properties $EventData.Properties
    } -Columns @(
        New-UDTableColumn -Property Name -Title Name -ShowSort
        New-UDTableColumn -Property PID -Title PID -ShowSort
        New-UDTableColumn -Property CPU -Title CPU -ShowSort
        New-UDTableColumn -Property Memory -Title 'Memory' -OnRender {
            New-UDTypography -Text "$($EventData.Memory.ToString('0.00')) MB"
        } -ShowSort
        New-UDTableColumn -Property 'Action' -OnRender {
            New-UDTooltip -TooltipContent { 'End Task' } -Content {
                New-UDIconButton -Icon (New-UDIcon -Icon 'stop') -OnClick {
                    Stop-Process -Id $_.Pid
                    Sync-UDElement -Id 'processes'
                }
            }
            # New-UDTooltip -TooltipContent {'Create dump file'} -Content {
            #     New-UDIconButton -Icon (New-UDIcon -Icon 'bug') -OnClick {
            #         # TODO

            #     }
            # }
        }
    ) -ShowPagination -PageSize 10 -ShowRefresh -Id 'processes' -ShowSearch -ShowSort -Dense
} -Icon @{
    type = 'icon'
}