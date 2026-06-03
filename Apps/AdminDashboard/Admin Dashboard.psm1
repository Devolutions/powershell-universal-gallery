function Get-DBTheme {
    $AntDesign = Get-UDTheme -Name 'AntDesign'
    $AntDesign.light.overrides.MuiChip = @{
        root = @{
            height = "24px"
            borderRadius = '4px'
            border = '1px solid'
            color = 'rgb(22, 119, 255)'
            backgroundColor = 'rgb(230, 244, 255)'
            borderColor = 'rgb(105, 177, 255)'
        }
        icon = @{
            fontSize = "12px"
        }
    }
    $AntDesign.light.overrides.MuiCard = @{
        root = @{
            borderRadius = "4px"
        }
    }
    $AntDesign.light.overrides.MuiCardHeader = @{
        root = @{
            paddingBottom = "5px"
        }
        title = @{
            color = 'rgb(140, 140, 140)'
            fontSize = "20px"
            fontFamily = '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"'
        }
    }
    $AntDesign.light.overrides.MuiCardContent = @{
        root = @{
            paddingTop = "5px"
        }
    }
    $AntDesign.light.overrides.MuiPaper = @{
        root = @{
            boxShadow = "unset"
            border = "1px solid rgb(140, 140, 140)"
        }
    }
    $AntDesign
}

function Get-DBStats {
    [PSCustomObject]@{
        PageViews           = Get-Random -Min 1000000 -Max 10000000
        PageViewsIncrease   = Get-Random -Minimum 5 -Maximum 90
        Users          = Get-Random -Min 10000 -Max 100000
        UsersIncrease  = Get-Random -Minimum 5 -Maximum 90
        Orders         = Get-Random -Min 1000 -Max 10000
        OrdersIncrease = Get-Random -Minimum 5 -Maximum 90
        Sales          = Get-Random -Min 10000 -Max 100000
        SalesIncrease  = Get-Random -Minimum 5 -Maximum 90
    }
}

function Get-DBUniqueVisitors {
    param(
        [ValidateSet("year", "month")]
        [Parameter()]
        $Period = "year"
    )

    if ($Period -eq "year")
    {
        1..12 | ForEach-Object {
            $Month = (Get-Date).AddMonths($_ * -1).ToString("MMM")

            [PSCustomObject]@{
                Month = $Month
                PageViews = Get-Random -Minimum 100000 -Maximum 1000000
                Users = Get-Random -Minimum 100000 -Maximum 1000000
            }
        }
    }
}

function Get-DBIncome {
    1..12 | ForEach-Object {
        $Month = (Get-Date).AddMonths($_ * -1).ToString("MMM")

        [PSCustomObject]@{
            Month = $Month
            Income = Get-Random -Minimum 1000 -Maximum 100000
        }
    }
}