# PowerShell Universal App Instructions

This document provides best practices and examples for creating apps (dashboards) in PowerShell Universal.

## Table of Contents

- [Getting Started](#getting-started)
- [App Structure](#app-structure)
- [Component Best Practices](#component-best-practices)
- [Event Handlers](#event-handlers)
- [Variable Scopes](#variable-scopes)
- [Tables and Data Display](#tables-and-data-display)
- [Forms and User Input](#forms-and-user-input)
- [Performance Tips](#performance-tips)
- [Debugging](#debugging)

---

## Getting Started

### Creating a Basic App

Every app starts with `New-UDApp`. This is the top-level cmdlet that defines your app:

```powershell
New-UDApp -Title 'My Dashboard' -Content {
    New-UDTypography -Text 'Hello, World!'
}
```

### Multi-Page Apps

For larger applications, organize content into multiple pages:

```powershell
$Pages = @()
$Pages += New-UDPage -Name 'Home' -Content {
    New-UDTypography -Text 'Welcome to the Dashboard'
}
$Pages += New-UDPage -Name 'Services' -Content {
    New-UDTable -Data (Get-Service | Select-Object -First 10)
}
$Pages += New-UDPage -Name 'Settings' -Content {
    New-UDTypography -Text 'Configuration Options'
}

New-UDApp -Title 'Multi-Page Dashboard' -Pages $Pages
```

---

## App Structure

### Header Customization

Customize the app header with colors, logo, and navigation:

```powershell
New-UDApp -Title 'Custom Dashboard' -Content {
    New-UDTypography -Text 'Dashboard Content'
} -HeaderColor 'white' -HeaderBackgroundColor '#1976d2' -Logo '/images/logo.png'
```

### Navigation Menu

Create a permanent navigation menu:

```powershell
New-UDApp -Content {
    New-UDTypography -Text 'Main Content'
} -Navigation (
    New-UDList -Children {
        New-UDListItem -Label "Home" -OnClick { Invoke-UDRedirect '/' }
        New-UDListItem -Label "Reports" -Children {
            New-UDListItem -Label "Daily" -OnClick { Invoke-UDRedirect '/daily' }
            New-UDListItem -Label "Weekly" -OnClick { Invoke-UDRedirect '/weekly' }
        }
        New-UDListItem -Label "Settings" -OnClick { Invoke-UDRedirect '/settings' }
    }
) -NavigationLayout permanent
```

---

## Component Best Practices

### Always Assign IDs to Interactive Components

When you need to reference a component later (for refreshing, getting values, etc.), always assign an ID:

```powershell
# Good - Component has an ID
New-UDTextbox -Id 'txtUsername' -Label 'Username'
New-UDButton -Text 'Submit' -OnClick {
    $username = (Get-UDElement -Id 'txtUsername').value
    Show-UDToast "Hello, $username!"
}

# Bad - No ID makes it impossible to reference
New-UDTextbox -Label 'Username'
```

### Use Grid for Layout

Organize components using the Grid system:

```powershell
New-UDGrid -Container -Children {
    New-UDGrid -Item -ExtraSmallSize 12 -MediumSize 6 -Children {
        New-UDCard -Title 'Left Panel' -Content {
            New-UDTypography -Text 'Content on the left'
        }
    }
    New-UDGrid -Item -ExtraSmallSize 12 -MediumSize 6 -Children {
        New-UDCard -Title 'Right Panel' -Content {
            New-UDTypography -Text 'Content on the right'
        }
    }
}
```

### Use Cards for Grouping Related Content

```powershell
New-UDCard -Title 'System Information' -Content {
    New-UDTypography -Text "Computer: $env:COMPUTERNAME"
    New-UDTypography -Text "OS: $((Get-CimInstance Win32_OperatingSystem).Caption)"
    New-UDTypography -Text "Memory: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB"
}
```

---

## Event Handlers

### Variable Scoping in Event Handlers

Variables from outer scopes are automatically available in event handlers:

```powershell
$WelcomeMessage = "Welcome to the Dashboard!"
New-UDButton -Text 'Show Message' -OnClick {
    Show-UDToast $WelcomeMessage
}
```

### Accessing Event Data

Use `$EventData` to access data from the component:

```powershell
New-UDSelect -Option {
    New-UDSelectOption -Name 'Option 1' -Value '1'
    New-UDSelectOption -Name 'Option 2' -Value '2'
    New-UDSelectOption -Name 'Option 3' -Value '3'
} -OnChange { 
    Show-UDToast -Message "Selected: $EventData" 
}
```

### Avoid Nested EventData Issues

When using nested components, store `$EventData` in a separate variable:

```powershell
# Good - Store EventData in a variable for nested components
New-UDTable -Columns @(
    New-UDTableColumn -Property 'Name' -Render {
        $Name = $EventData.Name  # Store the value
        New-UDButton -Text $Name -OnClick {
            Show-UDToast -Message "Clicked: $Name"  # Use the stored variable
        }
    }
) -Data $Data

# Bad - EventData gets overwritten in nested event handlers
New-UDTable -Columns @(
    New-UDTableColumn -Property 'Name' -Render {
        New-UDButton -Text $EventData.Name -OnClick {
            # $EventData here is different - it's the button's event data!
            Show-UDToast -Message $EventData.Name  # Won't work as expected
        }
    }
) -Data $Data
```

---

## Variable Scopes

PowerShell Universal provides three custom variable scopes for apps:

### Cache Scope (`$Cache:`)

Use for data shared across all users and sessions. Ideal for expensive queries:

```powershell
# Load data once, use everywhere
$Cache:AllComputers = Get-ADComputer -Filter * | Select-Object Name, DNSHostName

# Use in multiple components
New-UDTable -Data $Cache:AllComputers -Title 'Domain Computers'
```

### Session Scope (`$Session:`)

Use for user-specific data that persists across page navigations:

```powershell
New-UDButton -Text 'Remember My Choice' -OnClick {
    $Session:UserPreference = 'DarkMode'
}

New-UDDynamic -Content {
    if ($Session:UserPreference -eq 'DarkMode') {
        New-UDTypography -Text 'Dark mode is enabled'
    }
}
```

### Page Scope (`$Page:`)

Use for data specific to a single browser tab/window:

```powershell
New-UDForm -Content {
    New-UDTextbox -Id 'SearchTerm'
} -OnSubmit {
    $Page:LastSearch = $EventData.SearchTerm
    Sync-UDElement -Id 'SearchResults'
}

New-UDDynamic -Id 'SearchResults' -Content {
    if ($Page:LastSearch) {
        New-UDTypography -Text "Results for: $($Page:LastSearch)"
    }
}
```

---

## Tables and Data Display

### Simple Table

```powershell
$Data = @(
    @{Name = 'Server01'; Status = 'Running'; CPU = '25%'}
    @{Name = 'Server02'; Status = 'Stopped'; CPU = '0%'}
    @{Name = 'Server03'; Status = 'Running'; CPU = '45%'}
)

New-UDTable -Data $Data -Title 'Server Status'
```

### Table with Custom Columns and Features

```powershell
$Columns = @(
    New-UDTableColumn -Property Name -Title 'Server Name' -ShowSort -IncludeInSearch -IncludeInExport
    New-UDTableColumn -Property Status -Title 'Status' -ShowSort -ShowFilter -FilterType select
    New-UDTableColumn -Property CPU -Title 'CPU Usage' -ShowSort
    New-UDTableColumn -Property Actions -Title 'Actions' -Render {
        $ServerName = $EventData.Name
        New-UDButton -Text 'Restart' -OnClick {
            Show-UDToast "Restarting $ServerName..."
        }
    }
)

New-UDTable -Data $Data -Columns $Columns -ShowSearch -ShowPagination -ShowSelection -Export -Dense
```

### Server-Side Processing for Large Datasets

For large datasets, use `-LoadData` for server-side paging, sorting, and filtering:

```powershell
$Columns = @(
    New-UDTableColumn -Property Name -Title 'Name' -ShowFilter
    New-UDTableColumn -Property Value -Title 'Value' -ShowFilter
)

New-UDTable -Id 'LargeDataTable' -Columns $Columns -LoadData {
    # Get your full dataset
    $AllData = 1..10000 | ForEach-Object {
        @{ Name = "Record-$_"; Value = $_ }
    }
    
    # Apply filters
    foreach ($Filter in $EventData.Filters) {
        $AllData = $AllData | Where-Object -Property $Filter.Id -Match -Value $Filter.Value
    }
    
    # Apply search
    if ($EventData.Search) {
        $AllData = $AllData | Where-Object { 
            $_.Name -match $EventData.Search -or $_.Value -match $EventData.Search 
        }
    }
    
    $TotalCount = $AllData.Count
    
    # Apply sorting
    if (-not [string]::IsNullOrEmpty($EventData.OrderBy.Field)) {
        $Descending = $EventData.OrderDirection -ne 'asc'
        $AllData = $AllData | Sort-Object -Property $EventData.OrderBy.Field -Descending:$Descending
    }
    
    # Apply paging
    $AllData = $AllData | Select-Object -First $EventData.PageSize -Skip ($EventData.Page * $EventData.PageSize)
    
    # Return data
    $AllData | Out-UDTableData -Page $EventData.Page -TotalCount $TotalCount -Properties $EventData.Properties
} -ShowFilter -ShowSort -ShowPagination -ShowRefresh
```

---

## Forms and User Input

### Basic Form

```powershell
New-UDForm -Content {
    New-UDTextbox -Id 'Username' -Label 'Username' -Placeholder 'Enter username'
    New-UDTextbox -Id 'Email' -Label 'Email' -Type email
    New-UDSelect -Id 'Department' -Label 'Department' -Option {
        New-UDSelectOption -Name 'IT' -Value 'IT'
        New-UDSelectOption -Name 'HR' -Value 'HR'
        New-UDSelectOption -Name 'Finance' -Value 'Finance'
    }
    New-UDCheckbox -Id 'IsAdmin' -Label 'Administrator'
} -OnSubmit {
    Show-UDToast "User created: $($EventData.Username) in $($EventData.Department)"
}
```

### Form with Validation

```powershell
New-UDForm -Content {
    New-UDTextbox -Id 'Email' -Label 'Email'
    New-UDTextbox -Id 'Password' -Label 'Password' -Type password
} -OnValidate {
    $FormValid = $true
    
    if (-not $EventData.Email -match '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$') {
        $FormValid = $false
        New-UDValidationResult -ValidationError 'Invalid email format'
    }
    elseif ($EventData.Password.Length -lt 8) {
        $FormValid = $false
        New-UDValidationResult -ValidationError 'Password must be at least 8 characters'
    }
    else {
        New-UDValidationResult -Valid
    }
} -OnSubmit {
    Show-UDToast "Form submitted successfully!"
}
```

---

## Performance Tips

### Use Dynamic Components for Expensive Operations

Wrap expensive operations in `New-UDDynamic` to load them asynchronously:

```powershell
New-UDDynamic -Content {
    # This expensive query won't block the page load
    $Services = Get-Service | Where-Object Status -eq 'Running'
    New-UDTable -Data $Services
} -LoadingComponent {
    New-UDProgress -Circular
}
```

### Cache Expensive Data

```powershell
# Load once at app startup or on first request
if (-not $Cache:ADUsers) {
    $Cache:ADUsers = Get-ADUser -Filter * -Properties Department, Title | 
        Select-Object Name, SamAccountName, Department, Title
}

# Use cached data throughout the app
New-UDTable -Data $Cache:ADUsers
```

### Use AutoRefresh Wisely

```powershell
# Refresh every 30 seconds - be mindful of server load
New-UDDynamic -Id 'LiveData' -Content {
    $Processes = Get-Process | Select-Object -First 10 Name, CPU, WorkingSet
    New-UDTable -Data $Processes
} -AutoRefresh -AutoRefreshInterval 30000
```

### Sync Elements Instead of Full Page Refresh

```powershell
New-UDButton -Text 'Refresh Data' -OnClick {
    # Good - Only refresh the specific element
    Sync-UDElement -Id 'DataTable'
}

# Avoid refreshing the entire page unless necessary
```

---

## Debugging

### Enable Debug Logging

```powershell
$DebugPreference = 'Continue'

New-UDApp -Content {
    New-UDButton -Text 'Debug' -OnClick {
        Write-Debug "Button clicked at $(Get-Date)"
        # Debug messages appear in app logs
    }
}
```

### Display Toast Messages for Debugging

```powershell
New-UDButton -Text 'Check Value' -OnClick {
    $value = Get-UDElement -Id 'myTextbox'
    Show-UDToast ($value | ConvertTo-Json) -Duration 10000
}
```

### Use Modals to Display Complex Data

```powershell
New-UDButton -Text 'Show Debug Info' -OnClick {
    Show-UDModal -Content {
        New-UDElement -Tag 'pre' -Content {
            $debugInfo = @{
                User = $User
                Roles = $Roles
                Session = $Session:Data
            }
            $debugInfo | ConvertTo-Json -Depth 3
        }
    }
}
```

---

## Common Patterns

### Service Management Dashboard

```powershell
New-UDApp -Title 'Service Manager' -Content {
    New-UDDynamic -Id 'ServiceTable' -Content {
        $Services = Get-Service | Select-Object Name, 
            @{n='Status';e={$_.Status.ToString()}},
            @{n='StartType';e={$_.StartType.ToString()}}
        
        $Columns = @(
            New-UDTableColumn -Property Name -Title 'Service' -ShowSort -IncludeInSearch
            New-UDTableColumn -Property Status -Title 'Status' -ShowFilter -FilterType select
            New-UDTableColumn -Property StartType -Title 'Start Type'
            New-UDTableColumn -Property Actions -Title 'Actions' -Render {
                $ServiceName = $EventData.Name
                New-UDStack -Direction row -Spacing 1 -Children {
                    New-UDButton -Text 'Start' -Size small -OnClick {
                        Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
                        Sync-UDElement -Id 'ServiceTable'
                        Show-UDToast "Started $ServiceName"
                    }
                    New-UDButton -Text 'Stop' -Size small -OnClick {
                        Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
                        Sync-UDElement -Id 'ServiceTable'
                        Show-UDToast "Stopped $ServiceName"
                    }
                }
            }
        )
        
        New-UDTable -Data $Services -Columns $Columns -ShowSearch -ShowPagination -Dense
    }
}
```

### User Lookup Tool

```powershell
New-UDApp -Title 'User Lookup' -Content {
    New-UDCard -Title 'Search for User' -Content {
        New-UDForm -Content {
            New-UDTextbox -Id 'SearchUser' -Label 'Username or Email' -FullWidth
        } -OnSubmit {
            $Page:SearchResult = Get-ADUser -Filter "SamAccountName -like '*$($EventData.SearchUser)*' -or EmailAddress -like '*$($EventData.SearchUser)*'" -Properties *
            Sync-UDElement -Id 'Results'
        }
    }
    
    New-UDDynamic -Id 'Results' -Content {
        if ($Page:SearchResult) {
            New-UDCard -Title 'Search Results' -Content {
                New-UDList -Children {
                    foreach ($user in $Page:SearchResult) {
                        New-UDListItem -Label $user.Name -SecondaryText $user.EmailAddress
                    }
                }
            }
        }
    }
}
```

---

## MCP Server

If you have PowerShell Universal MCP Server, your AI agent can use the tools found within it to discover more about your apps and provide enhanced assistance. These tools can be used to find commands and parameters for Universal apps by inspecting the `Universal` module. 

- PowerShellUniversal_McpTools_Find-PsuAppCommand - Search for app commands.
- PowerShellUniversal_McpTools_Find-PsuAppCommandParameter - Get parameters for a specific app command.
- PowerShellUniversal_McpTools_Get-PsuAppCommandExample - Get examples for a specific app command.
- PowerShellUniversal_McpTools_Get-PsuAppInstructions - Returns this instructions file.

Always make sure to check parameters exist when using them in dashboards. Check examples to find out how to use commands properly.

## Additional Resources

- [PowerShell Universal Documentation](https://docs.powershelluniversal.com/apps)
- [Component Reference](https://docs.powershelluniversal.com/apps/components)
- [Community Forums](https://forums.ironmansoftware.com/)
- [Real World Examples](https://forums.ironmansoftware.com/t/real-world-examples/7000)
- [PowerShell Universal Gallery](https://powershelluniversal.com/gallery)
