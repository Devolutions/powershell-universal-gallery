New-UDPage -Url "/services" -Name "Services" -Content {
    New-UDDynamic -Id 'services' -Content {
        $Services = Get-Service -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject]@{
                Name   = $_.Name
                Status = $_.Status
            }
        } | Sort-Object -Property Name

        New-UDTable -Data $Services -ShowPagination -PageSize 10 -Columns @(
            New-UDTableColumn -Property Name -Title Name -ShowFilter -ShowSort
            New-UDTableColumn -Property Status -Title Status -ShowFilter -ShowSort
            New-UDTableColumn -Property x -Title 'Actions' -OnRender {
            
            }
        ) -ToolbarContent {
            New-UDIconButton -Icon (New-UDIcon -Icon 'refresh') -OnClick {
                Sync-UDElement -Id 'services'
            }
        } -Dense
    } -LoadingComponent {
        New-UDSkeleton
    }
} -Icon @{
    type = 'icon'
}