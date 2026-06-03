function New-PSUThemeBuilderApp {
    function New-UDColorPicker {
        [CmdletBinding()]
        param(
            [Parameter()]
            [string]$Id = [Guid]::NewGuid(),
            [Parameter()]
            [ScriptBlock]$OnChange,
            [Parameter()]
            [string]$Value,
            [Parameter()]
            [string]$Label
        )
    
        New-UDElement -Tag div -Content {
            New-UDElement -Tag span -Content { $Label } -Attributes @{
                style = @{
                    paddingLeft = "50px"
                }
            }
            New-UDElement -Id $Id -Tag "input" -Attributes @{
                value    = $Value
                type     = "color"
                onChange = $OnChange
                style    = @{
                    marginLeft = "20px"
                }
            }
        } -Attributes @{ 
            style = @{ 
                display          = "flex"
                'justifyContent' = 'space-between'
            }
        }
    }
    
    function Convert-HashtableToString {
        param (
            [Parameter(Mandatory = $true)]
            [hashtable]$Hashtable,
            [int]$Indent = 0
        )
    
        $output = ""
        $indentation = " " * $Indent
    
        foreach ($key in $Hashtable.Keys) {
            $value = $Hashtable[$key]
            if ($value -is [hashtable]) {
                # If the value is another hashtable, recurse
                $output += "$indentation$key = @{`n"
                $output += Convert-HashtableToString -Hashtable $value -Indent ($Indent + 4)
                $output += "$indentation}`n"
            }
            elseif ($value -is [array]) {
                # If the value is an array, format it as an array
                $arrayValues = $value -join ", "
                $output += "$indentation$key = @($arrayValues)`n"
            }
            elseif ($value -is [double] -or $value -is [int]) {
                $output += "$indentation$key = $value`n"
            }
            else {
                # Otherwise, treat it as a simple value
                $output += "$indentation$key = '$value'`n"
            }
        }
    
        return $output
    }
    
    $ThemeSchema = @{
        light = @{
            breakpoints = @{
                keys   = @("xs", "sm", "md", "lg", "xl")
                values = @(0, 600, 900, 1200, 1536)
            }
            direction   = "ltr"
            palette     = @{
                common            = @{
                    black = "#000"
                    white = "#fff"
                }
                primary           = @{
                    main         = "#1976d2"
                    light        = "#42a5f5"
                    dark         = "#1565c0"
                    contrastText = "#fff"
                }
                secondary         = @{
                    main         = "#9c27b0"
                    light        = "#ba68c8"
                    dark         = "#7b1fa2"
                    contrastText = "#fff"
                }
                error             = @{
                    main         = "#d32f2f"
                    light        = "#ef5350"
                    dark         = "#c62828"
                    contrastText = "#fff"
                }
                warning           = @{
                    main         = "#ed6c02"
                    light        = "#ff9800"
                    dark         = "#e65100"
                    contrastText = "#fff"
                }
                info              = @{
                    main         = "#0288d1"
                    light        = "#03a9f4"
                    dark         = "#01579b"
                    contrastText = "#fff"
                }
                success           = @{
                    main         = "#2e7d32"
                    light        = "#4caf50"
                    dark         = "#1b5e20"
                    contrastText = "#fff"
                }
                grey              = @{
                    '50'   = "#fafafa"
                    '100'  = '#f5f5f5'
                    '200'  = '#eeeeee'
                    '300'  = '#e0e0e0'
                    '400'  = '#bdbdbd'
                    '500'  = '#9e9e9e'
                    '600'  = '#757575'
                    '700'  = '#616161'
                    '800'  = '#424242'
                    '900'  = '#212121'
                    'A100' = '#f5f5f5'
                    'A200' = '#eeeeee'
                    'A400' = '#bdbdbd'
                    'A700' = '#616161'
                }
                contrastThreshold = 3
                tonalOffset       = 0.2
                text              = @{
                    primary   = "rgba(0, 0, 0, 0.87)"
                    secondary = "rgba(0, 0, 0, 0.6)"
                    disabled  = "rgba(0, 0, 0, 0.38)"
                }
                divider           = "rgba(0, 0, 0, 0.12)"
                background        = @{
                    "paper"   = "#fff"
                    "default" = "#fff"
                }
                action            = @{
                    "active"           = "rgba(0, 0, 0, 0.54)"
                    "hover"            = "rgba(0, 0, 0, 0.04)"
                    "hoverOpactiy"     = 0.04
                    "selected"         = "rgba(0, 0 ,0, 0.08)"
                    selectedOpacity    = 0.08
                    disabled           = "rgba(0, 0, 0, 0.26)"
                    disabledBackground = "rgba(0, 0, 0, 0.12)"
                    disabledOpacity    = 0.38
                    focus              = "rgba(0, 0, 0, 0.12)"
                    focusOpacity       = 0.12
                    activatedOpacity   = 0.12
                }
            }
            mixins      = @{
                toolbar = @{
                    minheight = 56
                }
            }
            typography  = @{
                htmlFontSize      = 16
                fontFamily        = '"Roboto", "Helvetica", "Arial", sans-serif'
                fontSize          = 14
                fontWeightLight   = 300
                fontWeightRegular = 400
                fontWeightMedium  = 500
                fontWeightBold    = 700
                h1                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 300
                    fontSize      = '6rem'
                    lineHeight    = 1.167
                    letterSpacing = '-0.01562em'
                }
                h2                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 300
                    fontSize      = '3.75rem'
                    lineHeight    = 1.2
                    letterSpacing = '-0.00833em'
                }
                h3                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '3rem'
                    lineHeight    = 1.167
                    letterSpacing = '0em'
                }
                h4                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '2.125rem'
                    lineHeight    = 1.235
                    letterSpacing = '0.00735em'
                }
                h5                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '1.5rem'
                    lineHeight    = 1.334
                    letterSpacing = '0em'
                }
                h6                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 500
                    fontSize      = '1.25rem'
                    lineHeight    = 1.6
                    letterSpacing = '0.0075em'
                }
                subtitle1         = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '1rem'
                    lineHeight    = 1.75
                    letterSpacing = '0.00938em'
                }
                subtitle2         = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 500
                    fontSize      = '0.875rem'
                    lineHeight    = 1.57
                    letterSpacing = '0.00714em'
                }
                body1             = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '1rem'
                    lineHeight    = 1.5
                    letterSpacing = '0.00938em'
                }
                body2             = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '0.875rem'
                    lineHeight    = 1.43
                    letterSpacing = '0.01071em'
                }
                button            = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 500
                    fontSize      = '0.875rem'
                    lineHeight    = 1.75
                    letterSpacing = '0.02857em'
                    textTransform = 'uppercase'
                }
                caption           = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '0.75rem'
                    lineHeight    = 1.66
                    letterSpacing = '0.03333em'
                }
                overline          = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '0.75rem'
                    lineHeight    = 2.66
                    letterSpacing = '0.08333em'
                    textTransform = 'uppercase'
                }
                inherit           = @{
                    fontFamily    = 'inherit'
                    fontWeight    = 'inherit'
                    fontSize      = 'inherit'
                    lineHeight    = 'inherit'
                    letterSpacing = 'inherit'
                }
            }
            zIndex      = @{
                mobileStepper = 1000
                fab           = 1050
                speedDial     = 1050
                appBar        = 1100
                drawer        = 1200
                modal         = 1300
                snackbar      = 1400
                tooltip       = 1500
            }
        }
        dark  = @{
            breakpoints = @{
                keys   = @("xs", "sm", "md", "lg", "xl")
                values = @(0, 600, 900, 1200, 1536)
            }
            direction   = "ltr"
            palette     = @{
                common            = @{
                    black = "#000"
                    white = "#fff"
                }
                primary           = @{
                    main         = "#90caf9"
                    light        = "#e3f2fd"
                    dark         = "#42af5f"
                    contrastText = "#rgba(0, 0, 0, 0.87)"
                }
                secondary         = @{
                    main         = "#ce93db"
                    light        = "#f3e5f5"
                    dark         = "#ab47bc"
                    contrastText = "#rgba(0, 0, 0, 0.87)"
                }
                error             = @{
                    main         = "#f44336"
                    light        = "#ef57373"
                    dark         = "#d32f2f"
                    contrastText = "#rgba(0, 0, 0, 0.87)"
                }
                warning           = @{
                    main         = "#ffa726"
                    light        = "#ffb74d"
                    dark         = "#f57c00"
                    contrastText = "#rgba(0, 0, 0, 0.87)"
                }
                info              = @{
                    main         = "#29b6fb"
                    light        = "#03a9f4"
                    dark         = "#9288d1"
                    contrastText = "#rgba(0, 0, 0, 0.87)"
                }
                success           = @{
                    main         = "#66bb6a"
                    light        = "#81c784"
                    dark         = "#388e3c"
                    contrastText = "#rgba(0, 0, 0, 0.87)"
                }
                grey              = @{
                    '50'   = "#fafafa"
                    '100'  = '#f5f5f5'
                    '200'  = '#eeeeee'
                    '300'  = '#e0e0e0'
                    '400'  = '#bdbdbd'
                    '500'  = '#9e9e9e'
                    '600'  = '#757575'
                    '700'  = '#616161'
                    '800'  = '#424242'
                    '900'  = '#212121'
                    'A100' = '#f5f5f5'
                    'A200' = '#eeeeee'
                    'A400' = '#bdbdbd'
                    'A700' = '#616161'
                }
                contrastThreshold = 3
                tonalOffset       = 0.2
                text              = @{
                    primary   = "#fff"
                    secondary = "rgba(255, 255, 255, 0.7)"
                    disabled  = "rgba(255, 255, 255, 0.5)"
                    icon      = "rgba(255, 255, 255, 0.12)"
                }
                divider           = "rgba(0, 0, 0, 0.12)"
                background        = @{
                    "paper"   = "#121212"
                    "default" = "#121212"
                }
                action            = @{
                    "active"           = "#fff"
                    "hover"            = "rgba(255, 255, 255, 0.08)"
                    "hoverOpactiy"     = 0.08
                    "selected"         = "rgba(255, 255, 255, 0.16)"
                    selectedOpacity    = 0.16
                    disabled           = "rgba(255, 255, 255, 0.3)"
                    disabledBackground = "rgba(255, 255, 255, 0.12)"
                    disabledOpacity    = 0.38
                    focus              = "rgba(255, 255, 255, 0.12)"
                    focusOpacity       = 0.12
                    activatedOpacity   = 0.24
                }
            }
            mixins      = @{
                toolbar = @{
                    minheight = 56
                }
            }
            typography  = @{
                htmlFontSize      = 16
                fontFamily        = '"Roboto", "Helvetica", "Arial", sans-serif'
                fontSize          = 14
                fontWeightLight   = 300
                fontWeightRegular = 400
                fontWeightMedium  = 500
                fontWeightBold    = 700
                h1                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 300
                    fontSize      = '6rem'
                    lineHeight    = 1.167
                    letterSpacing = '-0.01562em'
                }
                h2                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 300
                    fontSize      = '3.75rem'
                    lineHeight    = 1.2
                    letterSpacing = '-0.00833em'
                }
                h3                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '3rem'
                    lineHeight    = 1.167
                    letterSpacing = '0em'
                }
                h4                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '2.125rem'
                    lineHeight    = 1.235
                    letterSpacing = '0.00735em'
                }
                h5                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '1.5rem'
                    lineHeight    = 1.334
                    letterSpacing = '0em'
                }
                h6                = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 500
                    fontSize      = '1.25rem'
                    lineHeight    = 1.6
                    letterSpacing = '0.0075em'
                }
                subtitle1         = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '1rem'
                    lineHeight    = 1.75
                    letterSpacing = '0.00938em'
                }
                subtitle2         = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 500
                    fontSize      = '0.875rem'
                    lineHeight    = 1.57
                    letterSpacing = '0.00714em'
                }
                body1             = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '1rem'
                    lineHeight    = 1.5
                    letterSpacing = '0.00938em'
                }
                body2             = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '0.875rem'
                    lineHeight    = 1.43
                    letterSpacing = '0.01071em'
                }
                button            = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 500
                    fontSize      = '0.875rem'
                    lineHeight    = 1.75
                    letterSpacing = '0.02857em'
                    textTransform = 'uppercase'
                }
                caption           = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '0.75rem'
                    lineHeight    = 1.66
                    letterSpacing = '0.03333em'
                }
                overline          = @{
                    fontFamily    = '"Roboto", "Helvetica", "Arial", sans-serif'
                    fontWeight    = 400
                    fontSize      = '0.75rem'
                    lineHeight    = 2.66
                    letterSpacing = '0.08333em'
                    textTransform = 'uppercase'
                }
                inherit           = @{
                    fontFamily    = 'inherit'
                    fontWeight    = 'inherit'
                    fontSize      = 'inherit'
                    lineHeight    = 'inherit'
                    letterSpacing = 'inherit'
                }
            }
            zIndex      = @{
                mobileStepper = 1000
                fab           = 1050
                speedDial     = 1050
                appBar        = 1100
                drawer        = 1200
                modal         = 1300
                snackbar      = 1400
                tooltip       = 1500
            }
        }
    }
    
    function New-UDPalettePicker {
        param([string]$Palette)
    
        $Session:Theme[$Palette].palette.Keys | Sort-Object | ForEach-Object {
            $Group = $_
    
            if ($Group -eq 'divider') {
                New-UDColorPicker -Label "$group" -Value $Session:Theme[$Palette].palette[$group] -OnChange { 
                    $Session:Theme[$Palette].palette[$group] = $EventData 
                    Set-UDTheme -Theme $Session:Theme -Variant $Palette
                    Sync-UDElement -Id 'source'
                }
            }
            elseif ($Item -eq 'tonalOffest' -or $item -eq 'contrastThreshold') {
                return
            }
    
            $Session:Theme[$Palette].palette[$Group].Keys | Sort-Object | ForEach-Object {
                $Item = $_
    
                if ($Item.Contains("Opacity")) {
                    return
                }
    
                New-UDColorPicker -Label "$Group \ $_" -Value $Session:Theme[$Palette].palette[$Group][$Item] -OnChange { 
                    $Session:Theme[$Palette].palette[$group][$Item] = $EventData 
                    Set-UDTheme -Theme $Session:Theme -Variant $Palette
                    Sync-UDElement -Id 'source'
                }
            }
        }
    }
    
    New-UDApp -Title 'Theme Builder' -Content {
        $Session:Theme = $ThemeSchema
    
        New-UDRow -Columns {
            New-UDColumn -SmallSize 12 -LargeSize 2 -MediumSize 2 -Content {
                New-UDList -Children {
                    New-UDListItem -Label 'Colors' -Children {
                        New-UDListItem -Label 'Light' -Children {
                            New-UDPalettePicker -Palette 'light'
                        } -Icon (New-UDIcon -Icon 'sun') -Nested
                        New-UDListItem -Label 'Dark' -Children {
                            New-UDPalettePicker -Palette 'dark'
                        } -Icon (New-UDIcon -Icon 'moon') -Nested
                    } -Icon (New-UDIcon -Icon 'brush')
                } -Sx @{
                    minWidth = '350px'
                }
            }
            New-UDColumn -SmallSize 10 -LargeSize 10 -Content {
                New-UDElement -Content {
                    New-UDTabs -Tabs {
                        New-UDTab -Text "Preview" -Content {
                            New-UDAutocomplete -Options @('Test', 'Test2', 'Test3', 'Test4') -Id 'autocomplete1' -FullWidth
                            New-UDButton -Text 'Secondary' -Color secondary -Id 'button5'
                            New-UDButton -Text 'Success' -Color success -Id 'button6'
                            New-UDButton -Text 'Error' -Color error -Id 'button7'
                            New-UDButtonGroup -Content {
                                New-UDButtonGroupItem -Text 'Delete'
                                New-UDButtonGroupItem -Text 'Copy'
                            }
                            New-UDCheckbox -Label 'Demo' -Id 'checkbox1'
                            New-UDDatePicker -Id 'datepicker3' -Value '1-2-2020' -Variant static
                            New-UDFloatingActionButton -Icon (New-UDIcon -Icon 'user') -OnClick {
                                Show-UDToast -Message 'Hello'
                            } -Id 'fab1' -Position Relative
                            New-UDForm -Id 'form1' -Content {
                                New-UDTextbox -Id 'form1Textbox' -Label 'Name'
                            } -OnSubmit {
                                Show-UDToast -Message ($EventData.form1Textbox)
                            }
                            New-UDIconButton -Icon (New-UDIcon -Icon user -Size sm)  -Id 'iconButton1'
                            New-UDRadioGroup -Label 'group' -Id 'radio1' -Children {
                                New-UDRadio -Value 'Adam' -Label 'Adam'  -Id 'adam'
                                New-UDRadio -Value 'Sarah' -Label 'Sarah' -Id 'sarah'
                                New-UDRadio -Value 'Austin' -Label 'Austin' -Id 'austin'
                            }
                            New-UDRating -Value 3 -Id 'rating1'
                            New-UDSelect -Label 'Select' -Id 'select1' -Option {
                                New-UDSelectOption -Name "One" -Value 1
                                New-UDSelectOption -Name "Two" -Value 2
                                New-UDSelectOption -Name "Three" -Value 3
                            } -FullWidth
                            New-UDSlider -Value 50 -Minimum 0 -Maximum 100 -OnChange {
                                Show-UDToast -Message "Slider value changed to $($EventData.value)"
                            } -Id 'slider1'
                            New-UDSpeedDial -Content {
                                New-UDSpeedDialAction -Icon (New-UDIcon -Icon 'User') -TooltipTitle 'My Account'
                                New-UDSpeedDialAction -Icon (New-UDIcon -Icon 'Users') -TooltipTitle 'Groups'
                                New-UDSpeedDialAction -Icon (New-UDIcon -Icon 'Save') -TooltipTitle 'Save'
                                New-UDSpeedDialAction -Icon (New-UDIcon -Icon 'File') -TooltipTitle 'Open'
                            } -Icon (New-UDIcon -Icon 'Plus') -Id 'speedDial1'
                            New-UDSwitch -Id 'switch1' -Checked $true
                            New-UDToggleButtonGroup -Content {
                                New-UDToggleButton -Content {
                                    New-UDIcon -Icon 'User'
                                }
                                New-UDToggleButton -Content {
                                    New-UDIcon -Icon 'User'
                                }
                                New-UDToggleButton -Content {
                                    New-UDIcon -Icon 'User'
                                } -Id 'test'
                            } -Exclusive
                            New-UDTimePicker -Id 'timepicker1'
                            New-UDTransferList -Item {
                                New-UDTransferListItem -Name 'test1' -Value 1
                                New-UDTransferListItem -Name 'test2' -Value 2
                                New-UDTransferListItem -Name 'test3' -Value 3
                                New-UDTransferListItem -Name 'test4' -Value 4
                                New-UDTransferListItem -Name 'test5' -Value 5
                            } -Id 'transferlist1'
                            New-UDBadge -Color secondary -BadgeContent { 4 } -Children {
                                New-UDIcon -Icon Envelope -Size 2x
                            } -Id 'badge2'
                            New-UDBadge -Color error -BadgeContent { 4 } -Children {
                                New-UDIcon -Icon Envelope -Size 2x
                            } -Id 'badge3'
                            New-UDAvatar -Alt "Remy Sharp" -Image "/admin/logo.png"
                            New-UDChip -Label 'Basic' -Icon (New-UDIcon -Icon 'user') -Id 'chip1'
    
                            New-UDDataGrid -LoadRows {
                                $Rows = @(
                                    @{ Name = 'Adam'; Number = Get-Random }
                                    @{ Name = 'Tom'; Number = Get-Random }
                                    @{ Name = 'Sarah'; Number = Get-Random }
                                )
                                @{
                                    rows     = $Rows 
                                    rowCount = $Rows.Length
                                }
                            } -Columns @(
                                New-UDDataGridColumn -Field 'Name'
                                New-UDDataGridColumn -Field 'Number'
                            ) -Id 'dataGrid1'
                            New-UDList -Content {
                                New-UDListItem -Label 'Inbox' -Icon (New-UDIcon -Icon envelope -Size 3x) -SubTitle 'New Stuff'
                                New-UDListItem -Label 'Drafts' -Icon (New-UDIcon -Icon edit -Size 3x) -SubTitle "Stuff I'm working on "
                                New-UDListItem -Label 'Trash' -Icon (New-UDIcon -Icon trash -Size 3x) -SubTitle 'Stuff I deleted'
                                New-UDListItem -Label 'Spam' -Icon (New-UDIcon -Icon bug -Size 3x) -SubTitle "Stuff I didn't want"
                            } -Id 'list1'
                            $Rows = @(
                                @{Dessert = 'Frozen yoghurt'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0 }
                                @{Dessert = 'Ice cream sandwich'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0 }
                                @{Dessert = 'Eclair'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0 }
                                @{Dessert = 'Cupcake'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0 }
                                @{Dessert = 'Gingerbread'; Calories = 159; Fat = 6.0; Carbs = 24; Protein = 4.0 }
                            ) 
                            New-UDTable -Data $Rows -Id 'table1'
                            New-UDTimeline -Children {
                                New-UDTimelineItem -Content {
                                    'Breakfast'
                                } -OppositeContent {
                                    '7:45 AM'
                                }
                                New-UDTimelineItem -Content {
                                    'Welcome Message'
                                } -OppositeContent {
                                    '9:00 AM'
                                }
                                New-UDTimelineItem -Content {
                                    'State of the Shell'
                                } -OppositeContent {
                                    '9:30 AM'
                                }
                                New-UDTimelineItem -Content {
                                    'General Session'
                                } -OppositeContent {
                                    '11:00 AM'
                                }
                            } -Position alternate -Id 'timeline2'
                            @("h1", "h2", "h3", "h4", "h5", "h6", "subtitle1", "subtitle2", "body1", "body2", "caption", "button", "overline", "srOnly", "inherit", "display4", "display3", "display2", "display1", "headline", "title", "subheading") | ForEach-Object {
                                New-UDTypography -Variant $_ -Text $_ -GutterBottom
                                New-UDElement -Tag 'p' -Content {}
                            }
                            New-UDStack -Content {
                                New-UDAlert -Severity 'error'  -Title "Error" -Id 'alert1'
                                New-UDAlert -Severity 'warning' -Title "Warning" -Id 'alert2'
                                New-UDAlert -Severity 'info'  -Title "Info" -Id 'alert3'
                                New-UDAlert -Severity 'success' -Title "Success" -Id 'alert4'
                            } -Direction 'column'
                            New-UDProgress -Circular -Size large -Id 'progress2'
                            New-UDSkeleton -Id 'skeleton1' -Variant text -Animation wave -Width 210
                            New-UDAppBar -Children { New-UDTypography -Text 'Hello' } -Position relative
    
                            $Header = New-UDCardHeader -Avatar (New-UDAvatar -Content { "R" } -Sx @{ backgroundColor = "#f44336" }) -Action (New-UDIconButton -Icon (New-UDIcon -Icon 'EllipsisVertical')) -Title 'Shrimp and Chorizo Paella' -SubHeader 'September 14, 2016';
                            $Media = New-UDCardMedia -Image 'https://mui.com/static/images/cards/paella.jpg'
                            $CardBody = New-UDCardBody -Content {
                                New-UDTypography -Text ' This impressive paella is a perfect party dish and a fun meal to cook together with your guests. Add 1 cup of frozen peas along with the mussels, if you like.' -Sx @{
                                    color = 'text.secondary'
                                } -Variant body2
                            }
                            $Footer = New-UDCardFooter -Content {
                                New-UDIconButton -Icon (New-UDIcon -Icon 'Heart')
                                New-UDIconButton -Icon (New-UDIcon -Icon 'ShareAlt')
                            }
                            $Expand = New-UDCardExpand -Content {
                                $Description = "Heat oil in a (14- to 16-inch) paella pan or a large, deep skillet over medium-high heat. Add chicken, shrimp and chorizo, and cook, stirring occasionally until lightly browned, 6 to 8 minutes. Transfer shrimp to a large plate and set aside, leaving chicken and chorizo in the pan. Add pimentón, bay leaves, garlic, tomatoes, onion, salt and pepper, and cook, stirring often until thickened and fragrant, about 10 minutes. Add saffron broth and remaining 4 1/2 cups chicken broth; bring to a boil."
                                New-UDTypography -Text $Description
                            }
                            New-UDCard -Header $Header -Media $Media -Body $CardBody -Footer $Footer -Expand $Expand -Sx @{
                                maxWidth = 345
                                border   = '2px solid #f0f2f5'
                            } -Id 'card5'
                            New-UDExpansionPanelGroup -Id 'expandsionPanelGroup1' -Children {
                                New-UDExpansionPanel -Title "Hello" -Content {} -Active -Id 'expansionPanel1'
                                New-UDExpansionPanel -Title "Hello" -Content {
                                    New-UDElement -Tag 'div' -Content { "Hello" }
                                } -Id 'expansionPanel2'
                                New-UDExpansionPanel -Title "Hello" -Content {
                                    New-UDElement -Tag 'div' -id 'expEndpointDiv' -Content { "Hello" }
                                } -Id 'expansionPanel3'
                            }
                            New-UDBreadcrumbs -Content {
                                New-UDLink -Url "https://www.google.com" -Text "Google"
                                New-UDLink -Url "https://www.google.com" -Text "Google"
                                New-UDLink -Url "https://www.google.com" -Text "Google"
                            }
                            New-UDMenu -Text 'Click Me'  -Children {
                                New-UDMenuItem -Text 'Test'
                                New-UDMenuItem -Text 'Test2'
                                New-UDMenuItem -Text 'Test3'
                            } -Id 'menu1'
                            New-UDStepper -Id 'stepper1' -Steps {
                                New-UDStep -OnLoad {
                                    New-UDElement -tag 'div' -Content { "Step 1" }
                                    New-UDTextbox -Id 'txtStep1' 
                                } -Label "Step 1"
                                New-UDStep -OnLoad {
                                    New-UDElement -tag 'div' -Content { "Step 2" }
                                    New-UDElement -tag 'div' -Content { "Previous data: $Body" }
                                    New-UDTextbox -Id 'txtStep2' 
                                } -Label "Step 2"
                                New-UDStep -OnLoad {
                                    New-UDElement -tag 'div' -Content { "Step 3" }
                                    New-UDElement -tag 'div' -Content { "Previous data: $Body" }
                                    New-UDTextbox -Id 'txtStep3' 
                                } -Label "Step 3"
                            } -OnFinish {
                                New-UDTypography -Text 'Nice! You did it!' -Variant h3
                                New-UDElement -Tag 'div' -Id 'result' -Content { $Body }
                            }
                            New-UDTreeView -Node {
                                New-UDTreeNode -Name "Root Node" -Id "root1" -Children {
                                    New-UDTreeNode -Name "Child Node" -Id "child1" -Children {
                                        New-UDTreeNode -Name "Grandchild Node" -Id "grandchild1" -Leaf
                                    }
                                    New-UDTreeNode -Name "Child Node 2" -Id "child2" -Children {
                                        New-UDTreeNode -Name "Grandchild Node 2" -Id "grandchild2" -Leaf
                                    }
                                }
                            } -Id "treeview1"
                        }
                        New-UDTab -Text "Source" -Content {
                            New-UDDynamic -Id 'source' -Content {
                                $Theme = "@{`n$(Convert-HashtableToString -Hashtable $Session:Theme -Indent 4)`n}"
                                New-UDButton -Text 'copy' -Icon (New-UDIcon -Icon 'copy') -OnClick {
                                    Set-UDClipboard -Data $Theme -ToastOnSuccess
                                }
                                New-UDSyntaxHighlighter -Language 'powershell' -Code ($Theme)
                                
                            }
                        }
                      
                    }
                } -Attributes @{
                    style = @{
                        width      = '1000px'
                        marginLeft = "50px"
                    }
                } -Tag 'div'
    
            }
        }
    } -Theme $ThemeSchema -HeaderContent {
        New-UDButton -Icon (New-UDIcon -Icon 'refresh') -Text 'Reset Theme' -OnClick {
            $Session:Theme = $ThemeSchema
            Set-UDTheme -Theme $ThemeSchema
        }
    }
}