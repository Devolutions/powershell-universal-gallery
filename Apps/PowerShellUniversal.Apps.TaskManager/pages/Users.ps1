New-UDPage -Url "/users" -Name "Users" -Content {
    $Users = Get-CimInstance Win32_LoggedOnUser | Select-Object Antecedent -Unique | % { "{1}\{0}" -f $_.Antecedent.ToString().Split('"')[1], $_.Antecedent.ToString().Split('"')[3] } | ForEach-Object {
        [PSCustomObject]@{
            UserName = $_
        }
    }

    New-UDTable -Data $Users -Dense -Columns @(
        New-UDTableColumn -Title 'User Name' -Property 'UserName'
    ) -OnRowExpand {
        $UserProcesses = Get-Process -IncludeUserName | Where-Object UserName -EQ $EventData.UserName | Select-Object Name, Id
        New-UDTable -Data $UserProcesses
    }
} -Icon @{
    type = 'icon'
}