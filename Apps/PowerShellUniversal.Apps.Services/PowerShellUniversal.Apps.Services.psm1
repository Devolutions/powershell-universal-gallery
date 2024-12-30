function New-PSUServiceApp {
    New-UDApp -Content {
        New-UDDynamic -Id 'servicePage' -Content {
            if ($Session:SelectedService -eq $null) {
                New-PSUServiceTable
            }
            else {
                New-PSUServiceProperties
            }
        }
    }
}

function New-PSUServiceTable {
    
    New-UDDynamic -Id 'services' -Content {
        $Services = Get-Service -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.DisplayName
                Status      = $_.Status
                StartupType = $_.StartType
                UserName    = $_.UserName
            }
        } | Sort-Object -Property Name

        New-UDTable -Data $Services -ShowPagination -PageSize 10 -Columns @(
            New-UDTableColumn -Property Name -Title Name -ShowFilter -ShowSort
            New-UDTableColumn -Property Status -Title Status -ShowFilter -ShowSort
            New-UDTableColumn -Property StartupType -Title 'Startup Type' -ShowFilter -ShowSort
            New-UDTableColumn -Property UserName -Title 'Logon As' -ShowFilter -ShowSort
            New-UDTableColumn -Property x -Title 'Actions' -OnRender {
                New-PSUServiceControlButtons -Service $EventData -ShowProperties
            }
        ) -ToolbarContent {
            New-UDIconButton -Icon (New-UDIcon -Icon 'refresh') -OnClick {
                Sync-UDElement -Id 'services'
            }
        } -Dense
    } -LoadingComponent {
        New-UDSkeleton
    }
}

function New-PSUServiceProperties {
    $Service = Get-Service -Name $Session:SelectedService

    New-UDButton -Text 'Back' -Icon (New-UDIcon -Icon 'backward') -OnClick {
        $Session:SelectedService = $null
        Sync-UDElement -Id 'servicePage'
    }

    New-UDTabs -Tabs {
        New-UDTab -Text "General" -Content {
            New-PSUServiceGeneral
        }
        New-UDTab -Text "Log On" -Content {
            New-PSUServiceLogOn
        }
    }
}

function New-PSUServiceLogOn {
    New-UDPaper -Content {
        New-UDTypography -Text "Log on as:" -Variant subtitle1

        $Session:LogonAs = $Service.UserName

        New-UDSelect -DefaultValue $Session:LogonAs -Option {
            New-UDSelectOption -Name 'Local System' -Value 'LocalSystem'
            New-UDSelectOption -Name 'This Account' -Value 'ThisAccount'
        } -OnChange {
            $Session:LogonAs = $EventData
            Sync-UDElement -Id 'serviceLogonAs'
        }

        New-UDDynamic -Id 'serviceLogonAs' -Content {
            if ($Session:LogonAs -eq 'LocalSystem') {
                New-UDElement -Tag p -Content {
                    New-UDCheckbox -Label 'Allow service to interact with desktop' -OnChange {
                        #TODO Set-Service -Name $Service.Name 
                    }
                    New-UDButton -Text "Apply" -OnClick {
                        Set-Service -Name $Service.name -Credential:$null
                    }
                }
                
            }
            elseif ($Session:LogonAs -eq 'ThisAccount') {
                New-UDForm -Content {
                    New-UDStack -Direction column -Content {
                        New-UDTextbox -Id 'userName' -Label 'User Name'
                        New-UDTextbox -Id 'password' -Label 'Password' -Type password
                        New-UDTextbox -Id 'confirmPassword' -Label 'Confirm Password' -Type password
                    }
                } -OnSubmit {
                    $Password = ConvertTo-SecureString $EventData.Password -AsPlainText
                    $Credential = [PSCredential]::new($EventData.UserName, $Password)
                    Set-Service -Name $Service.Name -Credential $Credential
                } -OnValidate {
                    if ($EventData.Password -eq $null -or $EventData.UserName -eq $null) {
                        New-UDValidationResult -ValidationError 'Username or password is null'
                        return
                    }

                    if ($EventData.Password -cne $EventData.ConfirmPassword) {
                        New-UDValidationResult -ValidationError 'Passwords do not match'
                        return
                    }
                }
            
            }
        }
    } -Style @{ "display" = 'block' }
}

function New-PSUServiceGeneral {
    New-UDPaper -Content {
        @(
            "Service Name: $($Service.Name)"
            "Display Name: $($Service.DisplayName)"
            "Description: $($Service.DisplayName)"
            "Path to Executable: $($Service.BinaryPathName)"
        ) | ForEach-Object {
            New-UDTypography -Text $_ -Variant subtitle1
        }

        New-UDSelect -DefaultValue $Service.StartupType.ToString() -Option {
            New-UDSelectOption -Name 'Automatic (Delayed Start)' -Value 'AutomaticDelayedStart'
            New-UDSelectOption -Name 'Automatic' -Value 'Automatic'
            New-UDSelectOption -Name 'Manual' -Value 'Manual'
            New-UDSelectOption -Name 'Disabled' -Value 'Disabled'
        } -Label 'Startup Type' -OnChange {
            Set-Service -Name $Service.Name -StartupType $EventData
            Sync-UDElement -Id 'serviceStatus'
        }

        New-UDDivider -Sx @{
            marginTop = "10px"
        }

        New-UDDynamic -Id 'serviceStatus' -Content {
            New-UDTypography -Text "Service Status: $($Service.Status)" -Variant subtitle1
            New-PSUServiceControlButtons -Service $Service
        }
    } -Style @{ display = "block" }
}

function New-PSUServiceControlButtons {
    <#
        .SYNOPSIS
        Displays buttons to control a service
    #>
    param(
        [Parameter()]
        [Switch]$ShowProperties,
        [Parameter()]
        $Service
    )

    New-UDStack -Direction row -Content {
        if ($ShowProperties) {
            New-UDTooltip -TooltipContent {
                "Properties"
            } -Content {
                New-UDIconButton -Icon (New-UDIcon -Icon gear) -OnClick {
                    $Session:SelectedService = $Service.Name
                    Sync-UDElement -Id 'servicePage'
                    Sync-UDElement -Id 'services'
                }
            }
        }
        New-UDTooltip -TooltipContent {
            "Start"
        }  -Content {
            $Disabled = ($Service.Status -ne ([System.ServiceProcess.ServiceControllerStatus]::Stopped) -or $Service.StartType -eq ([System.ServiceProcess.ServiceStartMode]::Disabled))
            New-UDIconButton -Icon (New-UDIcon -Icon 'play') -Disabled:$Disabled -OnClick {
                Start-Service -Name $Service.Name
                Sync-UDElement -Id 'serviceStatus'
                Sync-UDElement -Id 'services'
            }
        }

        New-UDTooltip -TooltipContent {
            "Stop"
        } -Content {
            $Disabled = -not $Service.CanStop -and $Service.Status -ne ([System.ServiceProcess.ServiceControllerStatus]::Running)
            New-UDIconButton -Icon (New-UDIcon -Icon 'stop') -Disabled:$Disabled -OnClick {
                Stop-Service -Name $Service.Name
                Sync-UDElement -Id 'serviceStatus'
                Sync-UDElement -Id 'services'
            }
        }

        New-UDTooltip -TooltipContent {
            "Pause"
        } -Content {
            $Disabled = -not $Service.CanPauseAndContinue -or $Service.Status -ne ([System.ServiceProcess.ServiceControllerStatus]::Running)
            New-UDIconButton -Icon (New-UDIcon -Icon 'pause') -Disabled:$Disabled -OnClick {
                Start-Service -Name $Service.Name
                Sync-UDElement -Id 'serviceStatus'
                Sync-UDElement -Id 'services'
            }
        }
        New-UDTooltip -TooltipContent {
            "Resume"
        } -Content {
            $Disabled = -not $Service.CanPauseAndContinue -or $Service.Status -ne ([System.ServiceProcess.ServiceControllerStatus]::Paused)
            New-UDIconButton -Icon (New-UDIcon -Icon 'play') -Disabled:$Disabled  -OnClick {
                Start-Service -Name $Service.Name
                Sync-UDElement -Id 'serviceStatus'
                Sync-UDElement -Id 'services'
            }
        }
    }
}