
New-UDApp -Content {
    $Stats = Get-DBStats

    New-UDTypography -Text "Dashboard" -Variant h5 -Style @{ marginLeft = "10px"}
    New-UDLayout -Columns 4 -Content {
        New-UDCard -Title "Total Page Views" -Content {
            New-UDTypography -Content {
                $Stats.PageViews.ToString("N0")
                New-UDChip -Label "$($Stats.PageViewsIncrease)%" -Icon (New-UDIcon -Icon 'ChartLine' -Style @{ color = "rgb(22, 119, 255)"; }) -Style @{
                    marginLeft = "20px"
                }
            } -Variant h4
            New-UDTypography -Text "This static is based on the current year." -Variant subtitle1 -Style @{ color = 'rgb(140, 140, 140)'; marginTop = "5px" }
        }
        New-UDCard -Title "Total Users" -Content {
            New-UDTypography -Content {
                $Stats.Users.ToString("N0")
                New-UDChip -Label "$($Stats.UsersIncrease)%" -Icon (New-UDIcon -Icon 'ChartLine' -Style @{ color = "rgb(22, 119, 255)"; }) -Style @{
                    marginLeft = "20px"
                }
            } -Variant h4
            New-UDTypography -Text "This static is based on the current year." -Variant subtitle1 -Style @{ color = 'rgb(140, 140, 140)'; marginTop = "5px" }
        }
        New-UDCard -Title "Total Orders" -Content {
            New-UDTypography -Content {
                $Stats.Orders.ToString("N0")
                New-UDChip -Label "$($Stats.OrdersIncrease)%" -Icon (New-UDIcon -Icon 'ChartLine' -Style @{ color = "rgb(22, 119, 255)"; }) -Style @{
                    marginLeft = "20px"
                }
            } -Variant h4
            New-UDTypography -Text "This static is based on the current year." -Variant subtitle1 -Style @{ color = 'rgb(140, 140, 140)'; marginTop = "5px" }
        }
        New-UDCard -Title "Total Sales" -Content {
            New-UDTypography -Content {
                $Stats.Sales.ToString("C")
                New-UDChip -Label "$($Stats.SalesIncrease)%" -Icon (New-UDIcon -Icon 'ChartLine' -Style @{ color = "rgb(22, 119, 255)"; }) -Style @{
                    marginLeft = "20px"
                }
            } -Variant h4
            New-UDTypography -Text "This static is based on the current year." -Variant subtitle1 -Style @{ color = 'rgb(140, 140, 140)'; marginTop = "5px" }
        }
    }
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 8 -LargeSize 8 -Content {
            New-UDTypography -Text "Unique Users" -Variant h5 -Style @{ marginLeft = "10px"}
            New-UDCard -Body (New-UDCardBody -Style @{ height = "60vh"} -Content {
                $UniqueUsers = Get-DBUniqueVisitors
                New-UDChartJs -Type line -Data $UniqueUsers -LabelProperty "Month" -Dataset @(
                    New-UDChartJSDataset -DataProperty Users -BackgroundColor 'rgb(22, 119, 255, 0.1)' -AdditionalOptions @{
                        fill    = $true
                        tension = 0.4
                    } -BorderColor 'rgb(22, 119, 255)'  -BorderWidth '1' -Label "Users"
                    New-UDChartJSDataset -DataProperty PageViews -BackgroundColor 'rgb(22, 100, 255, 0.1)' -AdditionalOptions @{
                        fill    = $true
                        tension = 0.4
                    } -BorderColor 'rgb(22, 100, 255)' -BorderWidth '1' -Label "Page Views"
                ) 
            })
        }
        New-UDColumn -SmallSize 12 -MediumSize 4 -LargeSize 4 -Content {
            New-UDTypography -Text "Income Overview" -Variant h5 -Style @{ marginLeft = "10px"}

            New-UDCard -Body (New-UDCardBody -Style @{ height = "60vh"} -Content {
                $Income = Get-DBIncome
                New-UDChartJs -Type bar -Data $Income -LabelProperty "Month" -DataProperty "Income"  -BackgroundColor 'rgb(22, 119, 255, 0.1)' -Options @{
                    fill    = $true
                    tension = 0.4
                    responsive = $true
                } -BorderColor 'rgb(22, 119, 255)' -BorderWidth '1'
            })
        }
    }
} -Title "Admin Dashboard" -Theme (Get-DBTheme)