New-UDPage -Url "/account/:name" -Name "Account" -Content {
    $Account = Get-CRMAccount -Name $Name

    New-UDTypography -Text $Name -Variant h2
    New-UDAlert -Severity info -Text $Account.LastInteraction

    New-CRMNewContactButton -Account $Name

    New-UDTabs -Tabs {
        New-UDTab -Text "Contacts" -Content {
            New-CRMContactTable -Account $Name
        } -Icon (New-UDIcon -Icon "Users")
        New-UDTab -Text "Deals" -Content {

        } -Icon (New-UDIcon -Icon "DollarSign")
        New-UDTab -Text "History" -Content {

        } -Icon (New-UDIcon -Icon "History")
        New-UDTab -Text "Communication" -Content {

        } -Icon (New-UDIcon -Icon "Comment")
    }
} -AutoInclude