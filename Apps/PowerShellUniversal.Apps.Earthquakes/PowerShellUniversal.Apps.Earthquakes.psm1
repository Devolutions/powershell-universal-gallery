function New-UDEarthquakesApp {
    New-UDApp -Content {
        $Today = (Get-Date).ToString("yyyy-MM-dd")
        $Yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
    
        $GeoJson = Invoke-RestMethod "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$Yesterday&endtime=$Today"
    
        $Icons = @{
            Small  = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<svg height="100" width="100" xmlns="http://www.w3.org/2000/svg"><circle r="45" cx="50" cy="50" fill="green" stroke="green" stroke-width="3"  /></svg>'))
            Medium = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<svg height="100" width="100" xmlns="http://www.w3.org/2000/svg"><circle r="45" cx="50" cy="50" fill="yellow" stroke="green" stroke-width="3" /></svg>'))
            Large  = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<svg height="100" width="100" xmlns="http://www.w3.org/2000/svg"><circle r="45" cx="50" cy="50" fill="red" stroke="green" stroke-width="3"  /></svg>'))
        }
    
        New-UDMap -Content {
            New-UDMapLayerControl -Content {
                New-UDMapBaseLayer -Name 'Color' -Content {
                    New-UDMapRasterLayer -TileServer 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' 
                } -Checked
                New-UDMapOverlay -Name "Earthquakes" -Content {
                    New-UDMapFeatureGroup -Content { 
                        $GeoJson.features | ForEach-Object {
                            if ($_.properties.mag -lt 1) {
                                $Size = 5
                                $IconSvg = $Icons.Small
                            }
                            elseif ($_.properties.mag -lt 3) {
                                $Size = 5 * $_.properties.mag
                                $IconSvg = $Icons.Small
                            }
                            elseif ($_.properties.mag -lt 5) {
                                $Size = 5 * $_.properties.mag
                                $IconSvg = $Icons.Medium
                            }
                            else {
                                $Size = 5 * $_.properties.mag
                                $IconSvg = $Icons.Large
                            }
    
                            $Popup = New-UDMapPopup -Content { 
                                $Timestamp = ([DateTimeOffset]::FromUnixTimeSeconds($_.properties.time / 1000)).UtcDateTime.ToString('yyyy-MM-dd HH:mm:ss')
                                New-UDTypography -Text "$($_.properties.place)" -Variant h4
                                New-UDTypography -Text "Magnitude: $($_.properties.mag)" -Variant h5
                                New-UDTypography -Text "Time (UTC): $Timestamp" -Variant h5
                                New-UDTypography -Variant h5 -Content {
                                    New-UDLink -Url $_.properties.url -OpenInNewWindow -Text "More Information"
                                }
                            } -MinWidth 500
    
                            $Icon = New-UDMapIcon -Url "data:image/svg+xml;base64,$IconSvg" -Width $Size -Height $Size
                            New-UDMapMarker -Latitude $_.geometry.coordinates[1] -Longitude $_.geometry.coordinates[0] -Popup $Popup -Icon $Icon
                        }
                    }
                } -Checked
            }
        } -Height '75vh' -Latitude 39 -Longitude -94 -Zoom 4
    } -Title "Earthquakes in the last 24 hours"
}