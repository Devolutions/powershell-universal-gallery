function Format-Product {
    param($Name)

    $Icon = switch ($Name) {
        "Super Software Editor" { "edit" }
        "Super Software Server" { "server" }
        "Super Software Vault" { "vault" }
    }

    New-UDStack -Direction row -Children {
        New-UDIcon -Icon $Icon -Style @{
            padding = "5px"
        }
        New-UDTypography -Text $Name -Variant body2
    }
}

$Pages = @(
    New-UDPage -Name 'Licenses' -Content {
        New-UDStack -Direction column -AlignItems center -Children {
            New-UDIcon -Icon 'award' -Size 5x
            New-UDTypography -Text 'Licenses' -Variant h2
            New-UDTypography -Text 'Product licenses associated with your account' -Variant h5
        }

        $Licenses = Get-Content "$Repository\dashboards\$DashboardName\licenses.json" | ConvertFrom-Json

        [array]$Accounts = $Licenses.data | Group-Object -Property accountName

        $Accounts | Foreach-Object {
            $Account = $_

            $Body = New-UDCardBody -Content {
                New-UDAlert -Title "Universal Key" -Children {
                    $Key = $Account.Group | Where-Object UniversalKey -ne $null | Select-Object -ExpandProperty UniversalKey -First 1
                    New-UDStack -Direction row -Children {
                        New-UDTypography -Text $Key 
                        New-UDLink -Text 'Copy' -OnClick {
                            Set-UDClipboard -Data $Key -ToastOnSuccess
                        } -Style @{ marginLeft = "10px" }
                        New-UDLink -Text 'Share' -OnClick {
                            Invoke-UDRedirect -Url "https://bsky.app/intent/compose?text=$Key" -Native -OpenInNewWindow
                        } -Style @{ marginLeft = "10px" }
                        New-UDLink -Text 'Download .lic' -OnClick {
                            Start-UDDownload -ContentType 'text/plain' -FileName "license.lic" -StringData $Key
                        } -Style @{ marginLeft = "10px" }
                    } -JustifyContent space-between
                } -Severity info

                $Licenses = $Account.Group | ForEach-Object {
                    [PSCustomObject]@{
                        Product = $_.AssetName
                        Users   = $_.Licenses.userCount
                    }
                } | Where-Object Users -gt 0

                New-UDTable -Columns @(
                    New-UDTableColumn -Title 'Product' -Property "Product" -OnRender {
                        Format-Product -Name $EventData.Product
                    }
                    New-UDTableColumn -Title 'Users' -Property "Users"
                ) -Data $Licenses
            }

            $Footer = New-UDCardFooter -Content {
                New-UDElement -Content {
                    New-UDStack -Direction row -Children {
                        New-UDIcon -Icon "history" -Style @{
                            padding = "5px"
                        }
                        New-UDTypography -Text 'Expires in one year'
                        New-UDLink -Text "Renew" -OnClick {
                            Invoke-UDRedirect -Url "mailto:support@supersoftware.com" -OpenInNewWindow -Native
                        } -Style @{ paddingLeft = "10px" }
                    } -JustifyContent flex-end
                } -Attributes @{
                    style = @{
                        padding = "10px"
                        float   = "right"
                        width   = "100%"
                    }
                }


            }

            New-UDCard -Body $Body -Footer $Footer
        }
    } -Icon (New-UDIcon -Icon 'award' -Style @{ marginRight = "10px" })
    New-UDPage -Name 'Billing' -Content {
        $Orders = Get-Content "$Repository\dashboards\$DashboardName\orders.json" | ConvertFrom-Json

        New-UDTable -Title "Order History" -Data $Orders.Data -Columns @(
            New-UDTableColumn -Property 'OrderDate' -Title "Order Date" -OnRender {
                New-UDDateTime -InputObject $EventData.OrderDate
            }
            New-UDTableColumn -Property 'SKU' -Title "Product" -OnRender {
                Format-Product -Name $EventData.SKU
            }
            New-UDTableColumn -Property 'Quantity' -Title "Quantity" 
            New-UDTableColumn -Property 'Total' -Title "Order Total" -OnRender {
                New-UDTypography -Text "$($EventData.Total) USD"
            }
        ) -ShowExport -ShowSearch -ShowSort
    } -Icon (New-UDIcon -Icon 'CartShopping' -Style @{ marginRight = "10px" })
    New-UDPage -Name 'Profile' -Content {
        New-UDCard -Title 'Profile' -Avatar (New-UDIcon -Icon 'user' -Size 2x) -Content {
            New-UDTypography -Text "Update your user profile so we know how to contact you." -Variant display3

            $ProfileData = Get-PSUCache -Key "UserProfile_$User"
            New-UDForm -Children {
                New-UDTextbox -Disabled -Value $User
                New-UDTextbox -Id 'firstName' -Label 'First Name' -Value $ProfileData.FirstName
                New-UDTextbox -Id 'lastName' -Label 'Last Name' -Value $ProfileData.LastName
                New-UDTextbox -Id 'emailAddress' -Label 'Email Address' -Type email -Value $ProfileData.EmailAddress
            } -OnSubmit {
                Set-PSUCache -Integrated -Key "UserProfile_$User" -Value $EventData -Persist
                Show-UDSnackbar -Message "Success!" -Variant success
            }
        }
    } -Icon (New-UDIcon -Icon 'user' -Style @{ marginRight = "10px" })
    New-UDPage -Name 'Support Center' -Content {
        New-UDDynamic -Id "ChatHistory" -Content {
            if ($Session:ChatHistory -eq $null) {
                $Session:ChatHistory = [System.Collections.Generic.List[PSObject]]::new()
            }

            $Responses = Get-Content "$Repository\dashboards\$DashboardName\responses.json" | ConvertFrom-Json

            New-UDCard -Title 'Chat with Support' -Content {
                New-UDCard -Style @{ backgroundColor = "#E8E8E8"; height = "65vh"; overflow = "auto" } -Content {
                    $Items = $Session:ChatHistory
                    $Items | ForEach-Object {
                        New-UDStyle -Id "$($_.Id)Style" -Content {
                            if ($_.User -eq $User) {
                                New-UDCard -Id $_.Id -Title $_.User -Avatar (New-UDIcon -Icon "User" -Size 2x) -Content {
                                    New-UDChip -Label $_.TimeStamp
                                    New-UDElement -Content {
                                        New-UDTypography -Text $_.Message
                                    } -Tag 'p'
                                    
                                } -Style @{ width = "30%;"; marginLeft = "70%"; borderRadius = "5px" }
                            }
                            else {
                                New-UDCard -Id $_.Id -Title $_.User -Avatar (New-UDIcon -Icon "Robot" -Size 2x) -Content {
                                    New-UDChip -Label $_.TimeStamp
                                    New-UDElement -Content {
                                        New-UDTypography -Text $_.Message
                                    } -Tag 'p'
                                } -Style @{ width = "30%;"; marginRight = "70%"; borderRadius = "5px" }
                            }
                        } -Style ".MuiCardHeader-root { padding: 0px !important;} .MuiCardHeader-avatar { padding: 5px !important;}"

                    }

                    if ($Session:LoadingResponse) {
                        New-UDProgress -Circular -Label "..."
                    }
                } 


                New-UDTextbox -Id 'txtChat' -OnEnter {
                    $Session:ChatHistory.Add([PSCustomObject]@{
                            Id        = New-Guid
                            User      = $User
                            Message   = $EventData
                            TimeStamp = Get-Date
                        }) | Out-Null

                    $Session:LoadingResponse = $true

                    Sync-UDElement -Id 'ChatHistory'

                    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 5)

                    $Response = $Responses.Data | Where-Object { $EventData -match $_.match } | Select-Object -First 1

                    $Session:ChatHistory.Add([PSCustomObject]@{
                            Id        = New-Guid
                            User      = "Support Bot"
                            Message   = $Response.Response
                            TimeStamp = Get-Date
                        }) | Out-Null

                    $Session:LoadingResponse = $false

                    Sync-UDElement -Id 'ChatHistory'

                } -Placeholder "Send message..." -FullWidth -Icon (New-UDIcon -Icon comment)
            }
        }
    } -Icon (New-UDIcon -Icon 'headset' -Style @{ marginRight = "10px" })
)

New-UDApp -Title "Super Software Portal" -Pages $Pages -NavigationLayout Permanent