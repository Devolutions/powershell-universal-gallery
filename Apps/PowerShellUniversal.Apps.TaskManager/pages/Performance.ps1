New-UDPage -Url "/performance" -Name "Performance" -Content {
    New-UDTabs -Tabs {
        New-UDTab -Text 'CPU' -Content {
            New-UDPaper -Style @{ display = "block"; maxHeight = '100vh' } -Children {
                New-UDTypography -Text $Cache:ComputerInfo.CsProcessors.Name -Variant h4

                New-UDDynamic -AutoRefresh -AutoRefreshInterval 3 -Content {
                    New-UDElement -Content {
                        New-UDTypography -Text "CPU % Utilization" -Variant subtitle1
                        New-UDChartJS -Data $Cache:CPUUsageHistory -DataProperty "Value" -LabelProperty "Timestamp" -Type Line -Id 'cpuUsage' -Options @{
                            line = @{
                                tension = 0
                                fill    = 'origin'
                            }
                        } -BorderColor 'teal' -BackgroundColor 'teal'
                    } -Attributes @{ style = @{ maxHeight = "50vh" } }

                    New-UDLayout -Columns 2 -Content {
                        New-UDTypography -Text "Uptime: $($Cache:ComputerInfo.OsUptime)" -Variant subtitle1
                        New-UDTypography -Text "Current Clock Speed: $($Cache:ComputerInfo.CsProcessors[0].CurrentClockSpeed / 1000) GHz" -Variant subtitle1
                        New-UDTypography -Text "Max Clock Speed: $($Cache:ComputerInfo.CsProcessors[0].MaxClockSpeed / 1000) GHz" -Variant subtitle1
                        New-UDTypography -Text "Architecture: $($Cache:ComputerInfo.CsProcessors[0].Architecture)" -Variant subtitle1
                        New-UDTypography -Text "Cores: $($Cache:ComputerInfo.CsProcessors[0].NumberOfCores)" -Variant subtitle1
                        New-UDTypography -Text "Processors: $($Cache:ComputerInfo.CsProcessors[0].NumberOfLogicalProcessors)" -Variant subtitle1
                        New-UDTypography -Text "Number of Processes: $($Cache:ComputerInfo.OsNumberOfProcesses)" -Variant subtitle1
                    }
                }
            }
        }
        New-UDTab -Text 'Memory' -Content {
            New-UDPaper -Style @{ display = "block" } -Children {
                New-UDDynamic -AutoRefresh -AutoRefreshInterval 3 -Content {
                    New-UDElement -Content {
                        New-UDTypography -Text "Memory Available MBs" -Variant subtitle1
                        New-UDChartJS -Data $Cache:MemoryUsageHistory -DataProperty "Value" -LabelProperty "Timestamp" -Type Line -Id 'memoryUsage' -Options @{
                            line = @{
                                tension = 0
                                fill    = 'origin'
                            }
                        } -BorderColor 'blue' -BackgroundColor 'blue'
                    } -Attributes @{ style = @{ maxHeight = "50vh" } }

                    New-UDLayout -Columns 2 -Content {
                        New-UDTypography -Text "Total Memory: $(($Cache:ComputerInfo.OsTotalVisibleMemorySize / 1MB).ToString('F2')) GB" -Variant subtitle1
                        New-UDTypography -Text "Free Memory: $(($Cache:ComputerInfo.OsFreePhysicalMemory / 1MB).ToString('F2')) GB" -Variant subtitle1
                    }
                }
            }
        }
        New-UDTab -Text 'Disk' -Content {
            New-UDPaper -Style @{ display = "block" } -Children {
                $Cache:Disks | ForEach-Object {
                    New-UDTypography -Text "Disk $($_.Number)" -Variant h4
                    New-UDTypography -Text "$($_.Name)" -Variant subtitle1

                    $Disk = $_

                    New-UDDynamic -AutoRefresh -AutoRefreshInterval 3 -Content {
                        New-UDTypography -Text "Disk % Active Time" -Variant subtitle1
                        New-UDElement -Content {
                            New-UDChartJS -Data $Disk.UsageHistory -DataProperty "Value" -LabelProperty "Timestamp" -Type Line -Id "diskUsage$($Disk.Number)"  -Options @{
                                line = @{
                                    tension = 0
                                    fill    = 'origin'
                                }
                            } -BorderColor 'red' -BackgroundColor 'red'
                        } -Attributes @{ style = @{ maxHeight = "50vh" } }
                    }

                    New-UDTypography -Text "Capacity: $($_.Size.ToString('F2')) GBs" -Variant subtitle1
                    New-UDTypography -Text "System: $($_.System)" -Variant subtitle1
                    New-UDTypography -Text "Bus Type: $($_.BusType)" -Variant subtitle1
                }
            }
        }
        New-UDTab -Text 'Network' -Content {
            New-UDPaper -Style @{ display = "block" } -Children {
                New-UDDynamic -AutoRefresh -AutoRefreshInterval 3 -Content {
                    New-UDElement -Content {
                        New-UDTypography -Text "Throughput (MBs)" -Variant subtitle1
                        New-UDChartJS -Data $Cache:NetworkUsageHistory -DataProperty "Value" -LabelProperty "Timestamp" -Type Line -Id 'networkUsage' -Options @{
                            line = @{
                                tension = 0
                                fill    = 'origin'
                            }
                        } -BorderColor 'blue' -BackgroundColor 'blue'
                    } -Attributes @{ style = @{ maxHeight = "50vh" } }

                    New-UDLayout -Columns 2 -Content {
                        Get-NetAdapter | ForEach-Object {
                            New-UDTypography -Text "Adapter: $($_.Name)" -Variant subtitle1
                        }
                    }
                }
            }
        }
    } -Orientation 'vertical'
} -Icon @{
    type = 'icon'
}