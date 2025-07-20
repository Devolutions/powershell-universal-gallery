class CRMAccount {
    [string]$Name
    [DateTime]$Created
    [string]$CreatedBy
    [DateTime]$LastInteraction
}

class CRMContact {
    [string]$FirstName
    [string]$LastName
    [DateTime]$Created
    [string]$CreatedBy
    [string]$Account
    [string]$EmailAddress
    [string]$Address
    [string]$Country
    [DateTime]$LastInteraction
}

function Get-CRMAccount {
    param($Name)

    $Accounts = Get-PSUCache -List -Integrated | Where-Object Key -Match 'CRMAccount_' | ForEach-Object {
        Get-PSUCache -Key $_.Key -Integrated
    }

    if ($Name)
    {
        $Accounts | Where-Object Name -eq $Name
    }
    else
    {
        $Accounts
    }
}

function Get-CRMContact {
    param($EmailAddress)

    $Items = Get-PSUCache -List -Integrated | Where-Object Key -Match 'CRMContact_' | ForEach-Object {
        Get-PSUCache -Key $_.Key -Integrated
    }

    if ($EmailAddress)
    {
        $Items | Where-Object EmailAddress -eq $EmailAddress
    }
    else
    {
        $Items
    }
}

function Remove-CRMAccount {
    param(
        [Parameter(Mandatory)]
        $Name
    )

    Remove-PSUCache -Key "CRMAccount_$Name" -Integrated
}

function Remove-CRMContact {
    param(
        [Parameter(Mandatory)]
        $EmailAddress
    )

    Remove-PSUCache -Key "CRMContact_$EmailAddress" -Integrated
}

function New-CRMAccount {
    param(
        [Parameter(Mandatory)]
        $Name
    )

    $Account = [CRMAccount]::new()
    $Account.Name = $Name
    $Account.Created = Get-Date 
    $Account.CreatedBy = $User
    
    Set-PSUCache -Key "CRMAccount_$Name" -Persist -Integrated -Value $Account

    $Account
}

function New-CRMContact {
    param(
        [Parameter(Mandatory)]
        $FirstName,
        [Parameter(Mandatory)]
        $LastName,
        [Parameter(Mandatory)]
        $EmailAddress,
        [Parameter(Mandatory)]
        $Account
    )

    $Item = [CRMContact]::new()
    $Item.FirstName = $FirstName
    $Item.LastName = $LastName
    $Item.EmailAddress = $EmailAddress
    $Item.Account = $Account
    $Item.Created = Get-Date
    $Item.CreatedBy = $User
    
    Set-PSUCache -Key "CRMContact_$EmailAddress" -Persist -Integrated -Value $Item

    $Item
}

function New-CRMNewAccountButton {
    New-UDButton -Text "New Account" -Icon (New-UDIcon -Icon "PlusCircle") -Style @{ float = 'right' } -OnClick {
        Show-UDModal -Content {
            New-UDForm -Children {
                New-UDTextbox -Placeholder "Name" -Id 'txtName'
            } -OnSubmit {
                New-CRMAccount -Name $EventData.txtName
                Hide-UDModal
                Sync-UDElement -Id 'accounts'
            } -OnValidate {
                if (-not $EventData.txtName) {
                    New-UDValidationResult -ValidationError "Name is required"
                }
                else {
                    New-UDValidationResult -Valid
                }
            }
        } -Header {
            New-UDIcon -Icon "PlusCircle" -Size 2x -Style @{ marginRight = '10px' }
            New-UDTypography -Text "Create new account" -Variant title
            New-UDDivider -Sx @{ marginTop = "10px" }
        }
    }
}

function New-CRMNewContactButton {
    param($Account)

    New-UDButton -Text "New Contact" -Icon (New-UDIcon -Icon "PlusCircle") -Style @{ float = 'right' } -OnClick {
        Show-UDModal -Content {
            New-UDForm -Children {
                New-UDTextbox -Placeholder "First Name" -Id 'txtFirstName'
                New-UDTextbox -Placeholder "Last Name" -Id 'txtLastName'
                New-UDTextbox -Placeholder "Email Address" -Id 'txtEmailAddress'

                if (-not $Account)
                {
                    New-UDAutocomplete -Id 'acAccount' -Options (Get-CRMAccount | ForEach-Object { New-UDAutocompleteOption -Name $_.Name -Value $_.Name})
                }
            } -OnSubmit {
                if (-not $Account)
                {
                    $Account = $EventData.acAccount
                }

                New-CRMContact -FirstName $EventData.txtFirstName -LastName $EventData.txtLastName -EmailAddress $EventData.txtEmailAddress -Account $Account
                Hide-UDModal
                Sync-UDElement -Id 'contacts'
            } -OnValidate {
                if (-not $EventData.txtFirstName) {
                    New-UDValidationResult -ValidationError "Name is required"
                }
                else {
                    New-UDValidationResult -Valid
                }
            }
        } -Header {
            New-UDIcon -Icon "PlusCircle" -Size 2x -Style @{ marginRight = '10px' }
            New-UDTypography -Text "Create new contact" -Variant title
            New-UDDivider -Sx @{ marginTop = "10px" }
        }
    }
}

function New-CRMContactTable 
{
    param($Account)

    New-UDTable -LoadRows {
        $Data = Get-CRMContact

        if ($Account)
        {
            $Data = $Data | Where-Object Account -eq $Account
        }

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
        New-UDTableColumn -Property "FirstName" -Title "First Name"
        New-UDTableColumn -Property "LastName" -Title "Last Name"
        New-UDTableColumn -Property "Account" -Title "Account"
        New-UDTableColumn -Property "Created" -Title "Created" -OnRender {
            New-UDDateTime -InputObject $EventData.Created
        }
        New-UDTableColumn -Property "CreatedBy" -Title "Created by"
        New-UDTableColumn -Property "LastInteraction" -Title "Last Interaction" -OnRender {
            New-UDDateTime -InputObject $EventData.LastInteraction
        }
        New-UDTableColumn -Property "Actions" -Title "Actions" -OnRender {
            $Name = $EventData.EmailAddress

            New-UDButton -Icon (New-UDIcon -Icon "Eye") -OnClick {
                Invoke-UDRedirect -Url "/contact/$Name"
            } -Color info -Text View

            New-UDButton -Icon (New-UDIcon -Icon "Trash") -OnClick {
                Remove-CRMContact -EmailAddress $Name
                Show-UDToast -Message "Deleted $Name"
                Sync-UDElement -Id 'contacts'
            } -Color error -Text Delete
        }
    ) -Id 'contacts' -Dense -ShowSearch -ShowFilter -ShowPagination -ShowRefresh -ShowSort
}