function Get-PSUAntDesignFrameworkAssetBasePath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    '/frameworks/ant-design'
}

function Get-PSUAntDesignFrameworkEntryPoint {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $basePath = Get-PSUAntDesignFrameworkAssetBasePath

    [pscustomobject]@{
        BasePath       = $basePath
        ScriptPath     = "$basePath/assets/antdesign-framework.js"
        StylesheetPath = "$basePath/assets/antdesign-framework.css"
    }
}

function New-UDAntDesignText {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string]$Id = ([guid]::NewGuid().ToString()),
        [Parameter(Mandatory)]
        [string]$Text
    )

    @{
        type = 'antd-text'
        id   = $Id
        text = $Text
    }
}

function Show-AntDesignMessage {
    <#
    .SYNOPSIS
    Shows an Ant Design global message in the current dashboard session.

    .DESCRIPTION
    Sends a dashboard websocket message through the built-in DashboardHub variable so the Ant Design client runtime can display a global message. Use this for lightweight feedback after an action completes or while work is in progress.

    .NOTES
    Use messages for short, non-blocking feedback such as success, warning, error, info, and loading states.
    When invoked inside a dashboard endpoint, the current ConnectionId is used automatically when available.
    Use -Broadcast to send the message to every connected client for the current dashboard.

    .PARAMETER Content
    Specifies the message content rendered by the Ant Design Message component.

    .PARAMETER Type
    Specifies the Ant Design message type.

    .PARAMETER Duration
    Specifies how long the message should stay visible, in seconds. Use 0 to keep it open until it is replaced or destroyed by a later update.

    .PARAMETER Key
    Specifies a stable key so later calls can update the same message instance.

    .PARAMETER Broadcast
    Sends the message to all connected clients for the current dashboard.

    .EXAMPLE
    New-UDAntDesignButton -Text 'Save Changes' -Type primary -OnClick {
        Show-AntDesignMessage -Content 'Saved changes.' -Type success
    }

    Displays a success message from a button click inside the current dashboard session.

    .EXAMPLE
    New-UDAntDesignButton -Text 'Start Sync' -OnClick {
        Show-AntDesignMessage -Content 'Sync in progress...' -Type loading -Duration 0 -Key 'sync-status'
    }

    Starts a persistent loading message that later endpoint calls can update by reusing the same key.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Alias('Message')]
        [string]$Content,
        [ValidateSet('info', 'success', 'warning', 'error', 'loading')]
        [string]$Type = 'info',
        [double]$Duration,
        [string]$Key,
        [switch]$Broadcast
    )

    if (-not $DashboardHub) {
        throw 'Show-AntDesignMessage requires the PowerShell Universal DashboardHub context.'
    }

    $targetConnectionId = Get-Variable -Name 'ConnectionId' -ValueOnly -ErrorAction Ignore

    $data = @{
        content = $Content
        type    = $Type
    }

    if ($PSBoundParameters.ContainsKey('Duration')) {
        $data.duration = $Duration
    }

    if ($PSBoundParameters.ContainsKey('Key')) {
        $data.key = $Key
    }

    if ($Broadcast) {
        $DashboardHub.SendWebSocketMessage('antdesign-message', $data)
        return
    }

    if ([string]::IsNullOrWhiteSpace($targetConnectionId)) {
        throw 'Show-AntDesignMessage requires -Broadcast or a ConnectionId in the current dashboard endpoint context.'
    }

    $DashboardHub.SendWebSocketMessage($targetConnectionId, 'antdesign-message', $data)
}

function Get-AntDesignHelpBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName
    )

    if (-not $script:AntDesignModuleSource) {
        $script:AntDesignModuleSource = Get-Content -Path $PSCommandPath -Raw
    }

    $pattern = "(?ms)function\s+$([regex]::Escape($CommandName))\s*\{\s*<#(?<help>.*?)#>"
    $match = [regex]::Match($script:AntDesignModuleSource, $pattern)

    if (-not $match.Success) {
        throw "Unable to locate comment-based help for $CommandName."
    }

    $match.Groups['help'].Value
}

function ConvertFrom-AntDesignExampleBlock {
    [CmdletBinding()]
    param(
        [string[]]$Lines,
        [int]$Index
    )

    $content = [System.Collections.Generic.List[string]]::new()

    foreach ($line in $Lines) {
        $content.Add($line.TrimEnd())
    }

    while ($content.Count -gt 0 -and [string]::IsNullOrWhiteSpace($content[0])) {
        $content.RemoveAt(0)
    }

    while ($content.Count -gt 0 -and [string]::IsNullOrWhiteSpace($content[$content.Count - 1])) {
        $content.RemoveAt($content.Count - 1)
    }

    $title = "Example $Index"

    if ($content.Count -gt 0 -and $content[0] -match '^#\s*(.+)$') {
        $title = $Matches[1].Trim()
        $content.RemoveAt(0)
    }

    $splitIndex = -1

    for ($lineIndex = 0; $lineIndex -lt $content.Count; $lineIndex++) {
        if ([string]::IsNullOrWhiteSpace($content[$lineIndex])) {
            $splitIndex = $lineIndex
            break
        }
    }

    if ($splitIndex -ge 0) {
        $codeLines = @($content.GetRange(0, $splitIndex))
        $descriptionLines = @($content.GetRange($splitIndex + 1, $content.Count - $splitIndex - 1))
    }
    else {
        $codeLines = @($content)
        $descriptionLines = @()
    }

    [ordered]@{
        title       = $title
        code        = ($codeLines -join [Environment]::NewLine).Trim()
        description = ($descriptionLines -join ' ').Trim()
    }
}

function ConvertFrom-AntDesignHelpList {
    [CmdletBinding()]
    param(
        [string]$Text
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return @()
    }

    @(
        $Text -split "`r?`n" |
            ForEach-Object { $_.Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            ForEach-Object { $_ -replace '^[\-\*\u2022]\s*', '' }
    )
}

function ConvertFrom-AntDesignHelpBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName
    )

    $helpBlock = Get-AntDesignHelpBlock -CommandName $CommandName
    $lines = @($helpBlock -split "`r?`n" | ForEach-Object { $_.TrimEnd() })

    $result = [ordered]@{
        Synopsis    = ''
        Description = ''
        Notes       = ''
        Parameters  = @{}
        Examples    = @()
    }

    $currentSection = $null
    $currentName = $null
    $buffer = [System.Collections.Generic.List[string]]::new()

    function Save-AntDesignHelpSection {
        param(
            [string]$Section,
            [string]$Name,
            [System.Collections.Generic.List[string]]$SectionBuffer
        )

        if ([string]::IsNullOrWhiteSpace($Section)) {
            return
        }

        $value = ($SectionBuffer.ToArray() -join [Environment]::NewLine).Trim()

        if ([string]::IsNullOrWhiteSpace($value)) {
            return
        }

        switch ($Section) {
            'Synopsis' {
                $result['Synopsis'] = $value
            }
            'Description' {
                $result['Description'] = $value
            }
            'Notes' {
                $result['Notes'] = $value
            }
            'Parameter' {
                $result.Parameters[$Name] = ($SectionBuffer.ToArray() -join ' ').Trim()
            }
            'Example' {
                $result['Examples'] += ,(ConvertFrom-AntDesignExampleBlock -Lines $SectionBuffer.ToArray() -Index ($result['Examples'].Count + 1))
            }
        }
    }

    foreach ($line in ($lines + '.END')) {
        $trimmedLine = $line.TrimStart()

        if ($trimmedLine -match '^\.(\w+)(?:\s+(.+))?$') {
            Save-AntDesignHelpSection -Section $currentSection -Name $currentName -SectionBuffer $buffer
            $buffer.Clear()

            switch ($Matches[1].ToUpperInvariant()) {
                'SYNOPSIS' {
                    $currentSection = 'Synopsis'
                    $currentName = $null
                }
                'DESCRIPTION' {
                    $currentSection = 'Description'
                    $currentName = $null
                }
                'NOTES' {
                    $currentSection = 'Notes'
                    $currentName = $null
                }
                'PARAMETER' {
                    $currentSection = 'Parameter'
                    $currentName = $Matches[2]
                }
                'EXAMPLE' {
                    $currentSection = 'Example'
                    $currentName = $null
                }
                Default {
                    $currentSection = $null
                    $currentName = $null
                }
            }

            continue
        }

        $buffer.Add($trimmedLine)
    }

    $result
}

function Invoke-AntDesignDocumentationExample {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Code
    )

    if ([string]::IsNullOrWhiteSpace($Code)) {
        return $null
    }

    try {
        & ([scriptblock]::Create($Code))
    }
    catch {
        New-UDAntDesignText -Text "Example preview failed: $($_.Exception.Message)"
    }
}

function Get-AntDesignCommandParameters {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName,
        [hashtable]$HelpParameters = @{}
    )

    $commonParameters = @(
        'Verbose',
        'Debug',
        'ErrorAction',
        'WarningAction',
        'InformationAction',
        'ProgressAction',
        'ErrorVariable',
        'WarningVariable',
        'InformationVariable',
        'OutVariable',
        'OutBuffer',
        'PipelineVariable'
    )

    $command = Get-Command -Name $CommandName -ErrorAction Stop

    foreach ($parameter in $command.Parameters.Values) {
        if ($parameter.Name -in $commonParameters) {
            continue
        }

        $parameterAttribute = $parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] } | Select-Object -First 1
        $validateSetAttribute = $parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] } | Select-Object -First 1

        [ordered]@{
            name        = $parameter.Name
            type        = $parameter.ParameterType.Name
            required    = [bool]($null -ne $parameterAttribute -and $parameterAttribute.Mandatory)
            description = $HelpParameters[$parameter.Name]
            validValues = if ($null -ne $validateSetAttribute) { @($validateSetAttribute.ValidValues) } else { @() }
        }
    }
}

function Get-AntDesignComponentDocumentation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Key,
        [Parameter(Mandatory)]
        [string]$Title,
        [Parameter(Mandatory)]
        [string]$CommandName,
        [string]$Category = 'General',
        [string]$SourceUrl
    )

    $help = ConvertFrom-AntDesignHelpBlock -CommandName $CommandName
    $examples = foreach ($example in $help.Examples) {
        [ordered]@{
            title       = $example.title
            description = $example.description
            code        = $example.code
            preview     = Invoke-AntDesignDocumentationExample -Code $example.code
        }
    }

    [ordered]@{
        key        = $Key
        title      = $Title
        category   = $Category
        commandName = $CommandName
        summary    = $help.Synopsis
        description = $help.Description
        whenToUse  = @(ConvertFrom-AntDesignHelpList -Text $help.Notes)
        sourceUrl  = $SourceUrl
        parameters = @(Get-AntDesignCommandParameters -CommandName $CommandName -HelpParameters $help.Parameters)
        examples   = @($examples)
    }
}

function New-UDAntDesignButton {
    <#
    .SYNOPSIS
    Creates an Ant Design button descriptor.

    .DESCRIPTION
    Creates an antd-button descriptor that maps the PowerShell command surface to the core Ant Design Button TypeScript definition used by the client runtime. The command mirrors the Ant Design Button API closely so the documented PowerShell examples can follow the same usage patterns as the upstream docs.

    .NOTES
    A button represents an operation or a short sequence of operations.
    Use a primary button for the main action in a section, and keep it to one primary action when possible.
    Use default buttons for secondary actions, dashed buttons for add-more style actions, text buttons for the least prominent actions, and link buttons for navigation.
    Use danger for destructive actions, ghost when the button sits on a strong background, disabled when the action is unavailable, and loading to prevent repeated submissions.

    .PARAMETER Id
    Specifies the component identifier used by PowerShell Universal for state and event routing.

    .PARAMETER Text
    Specifies the plain text content rendered inside the button.

    .PARAMETER Content
    Specifies descriptor content rendered inside the button when you need more than plain text.

    .PARAMETER Icon
    Specifies descriptor content rendered in the Ant Design icon slot.

    .PARAMETER Type
    Specifies the legacy Ant Design button type shortcut. Valid values are default, primary, dashed, link, and text.

    .PARAMETER Color
    Specifies the Ant Design button color token.

    .PARAMETER Variant
    Specifies the Ant Design button variant.

    .PARAMETER Shape
    Specifies the button shape.

    .PARAMETER Size
    Specifies the button size.

    .PARAMETER Disabled
    Disables the button.

    .PARAMETER Loading
    Shows the Ant Design loading state.

    .PARAMETER LoadingDelay
    Delays the loading spinner by the specified number of milliseconds.

    .PARAMETER LoadingIcon
    Specifies descriptor content or an Ant Design icon name rendered inside the loading indicator.

    .PARAMETER Ghost
    Renders the button with Ant Design ghost styling.

    .PARAMETER Danger
    Applies the Ant Design danger treatment.

    .PARAMETER Block
    Expands the button to the full available width.

    .PARAMETER Href
    Renders the button as a link when specified.

    .PARAMETER HtmlType
    Specifies the underlying HTML button type.

    .PARAMETER AutoInsertSpace
    Controls Ant Design automatic spacing for two Chinese characters.

    .PARAMETER IconPosition
    Specifies whether the icon renders before or after the button content.

    .PARAMETER ClassName
    Specifies a class name applied to the Ant Design button element.

    .PARAMETER RootClassName
    Specifies a root class name applied by Ant Design.

    .PARAMETER DataAttributes
    Specifies custom data attributes added to the rendered button. Keys are emitted as data-* attributes.

    .PARAMETER OnClick
    Specifies the endpoint invoked when the button is clicked.

    .PARAMETER Value
    Specifies the value sent back through the click event payload.

    .EXAMPLE
    # Syntactic sugar
    @(
        New-UDAntDesignButton -Text 'Primary Button' -Type primary
        New-UDAntDesignButton -Text 'Default Button' -Type default
        New-UDAntDesignButton -Text 'Dashed Button' -Type dashed
        New-UDAntDesignButton -Text 'Text Button' -Type text
        New-UDAntDesignButton -Text 'Link Button' -Type link -Href 'https://ant.design/components/button/'
    )

    Uses the Ant Design type shortcuts to mirror the core button styles from the upstream docs.

    .EXAMPLE
    # Color and variant
    @(
        New-UDAntDesignButton -Text 'Primary Solid' -Color primary -Variant solid
        New-UDAntDesignButton -Text 'Default Outlined' -Color default -Variant outlined
        New-UDAntDesignButton -Text 'Success Filled' -Color green -Variant filled
        New-UDAntDesignButton -Text 'Danger Text' -Color danger -Variant text -Danger
        New-UDAntDesignButton -Text 'Geekblue Link' -Color geekblue -Variant link -Href 'https://ant.design/components/button/'
    )

    Combines color and variant to show the newer styling model behind the Ant Design type aliases.

    .EXAMPLE
    # Icon
    @(
        New-UDAntDesignButton -Text 'Search Primary' -Type primary -Icon 'SearchOutlined'
        New-UDAntDesignButton -Text 'Download File' -Icon 'DownloadOutlined'
        New-UDAntDesignButton -Text 'External Link' -Type link -Icon 'LinkOutlined' -Href 'https://ant.design/components/button/'
    )

    Adds Ant Design icons through the PowerShell command surface while keeping the same button API.

    .EXAMPLE
    # Icon placement
    @(
        New-UDAntDesignButton -Text 'Search Start' -Type primary -Icon 'SearchOutlined' -IconPosition start
        New-UDAntDesignButton -Text 'Search End' -Type primary -Icon 'SearchOutlined' -IconPosition end
    )

    Moves the icon before or after the label to match the icon placement examples from the docs.

    .EXAMPLE
    # Size
    @(
        New-UDAntDesignButton -Text 'Large Action' -Type primary -Size large
        New-UDAntDesignButton -Text 'Medium Action' -Type default -Size middle
        New-UDAntDesignButton -Text 'Small Action' -Type dashed -Size small
    )

    Shows the three Ant Design button sizes exposed by the PowerShell wrapper.

    .EXAMPLE
    # Disabled
    @(
        New-UDAntDesignButton -Text 'Primary Disabled' -Type primary -Disabled
        New-UDAntDesignButton -Text 'Default Disabled' -Type default -Disabled
        New-UDAntDesignButton -Text 'Dashed Disabled' -Type dashed -Disabled
        New-UDAntDesignButton -Text 'Text Disabled' -Type text -Disabled
        New-UDAntDesignButton -Text 'Link Disabled' -Type link -Disabled -Href 'https://ant.design/components/button/'
    )

    Disables each style to document the unavailable state consistently.

    .EXAMPLE
    # Loading
    @(
        New-UDAntDesignButton -Text 'Saving Changes' -Type primary -Loading
        New-UDAntDesignButton -Text 'Queued Request' -Loading -LoadingDelay 400
        New-UDAntDesignButton -Text 'Syncing Data' -Type default -Loading -LoadingIcon 'LoadingOutlined'
    )

    Uses loading states to communicate in-progress work and to discourage repeated clicks.

    .EXAMPLE
    # Multiple buttons
    @(
        New-UDAntDesignButton -Text 'Primary Action' -Type primary
        New-UDAntDesignButton -Text 'Secondary Action' -Type default
        New-UDAntDesignButton -Text 'More Actions' -Type dashed -Icon 'EllipsisOutlined'
    )

    Follows the Ant Design guidance of one primary action plus secondary actions in the same group.

    .EXAMPLE
    # Ghost button
    @(
        New-UDAntDesignButton -Text 'Ghost Primary' -Type primary -Ghost
        New-UDAntDesignButton -Text 'Ghost Default' -Type default -Ghost
        New-UDAntDesignButton -Text 'Ghost Dashed' -Type dashed -Ghost
    )

    Shows the transparent ghost treatment that is useful on stronger or more colorful backgrounds.

    .EXAMPLE
    # Danger buttons
    @(
        New-UDAntDesignButton -Text 'Delete Record' -Type primary -Danger
        New-UDAntDesignButton -Text 'Danger Default' -Type default -Danger
        New-UDAntDesignButton -Text 'Danger Text' -Type text -Danger
        New-UDAntDesignButton -Text 'Danger Link' -Type link -Danger -Href 'https://ant.design/components/button/'
    )

    Applies the danger treatment for destructive or high-risk actions.

    .EXAMPLE
    # Block button
    @(
        New-UDAntDesignButton -Text 'Full Width Primary' -Type primary -Block
        New-UDAntDesignButton -Text 'Full Width Default' -Type default -Block
    )

    Expands buttons to the available width to match the block layout from the Ant Design docs.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string]$Id = ([guid]::NewGuid().ToString()),
        [string]$Text,
        [object]$Content,
        [object]$Icon,
        [ValidateSet('default', 'primary', 'dashed', 'link', 'text')]
        [string]$Type,
        [ValidateSet('default', 'primary', 'danger', 'blue', 'purple', 'cyan', 'green', 'magenta', 'pink', 'red', 'orange', 'yellow', 'volcano', 'geekblue', 'lime', 'gold')]
        [string]$Color,
        [ValidateSet('outlined', 'dashed', 'solid', 'filled', 'text', 'link')]
        [string]$Variant,
        [ValidateSet('default', 'circle', 'round')]
        [string]$Shape,
        [ValidateSet('small', 'middle', 'large')]
        [string]$Size,
        [switch]$Disabled,
        [switch]$Loading,
        [int]$LoadingDelay,
        [object]$LoadingIcon,
        [switch]$Ghost,
        [switch]$Danger,
        [switch]$Block,
        [string]$Href,
        [ValidateSet('submit', 'button', 'reset')]
        [string]$HtmlType,
        [bool]$AutoInsertSpace,
        [ValidateSet('start', 'end')]
        [string]$IconPosition,
        [string]$ClassName,
        [string]$RootClassName,
        [hashtable]$DataAttributes,
        [Endpoint]$OnClick,
        [object]$Value
    )

    if (-not $PSBoundParameters.ContainsKey('Text') -and -not $PSBoundParameters.ContainsKey('Content')) {
        throw 'New-UDAntDesignButton requires -Text or -Content.'
    }

    if ($null -ne $OnClick -and $OnClick.PSObject.Methods.Name -contains 'Register') {
        $OnClick.Register($Id, $PSCmdlet)
    }

    $descriptor = @{
        type = 'antd-button'
        id   = $Id
    }

    if ($PSBoundParameters.ContainsKey('Text')) {
        $descriptor.text = $Text
    }

    if ($PSBoundParameters.ContainsKey('Content')) {
        $descriptor.content = $Content
    }

    if ($PSBoundParameters.ContainsKey('Icon')) {
        $descriptor.icon = $Icon
    }

    if ($PSBoundParameters.ContainsKey('Type')) {
        $descriptor.buttonType = $Type
    }

    foreach ($property in 'Color', 'Variant', 'Shape', 'Size', 'Href', 'HtmlType', 'IconPosition', 'ClassName', 'RootClassName') {
        if ($PSBoundParameters.ContainsKey($property)) {
            $descriptor[$property.Substring(0, 1).ToLowerInvariant() + $property.Substring(1)] = $PSBoundParameters[$property]
        }
    }

    foreach ($switchProperty in 'Disabled', 'Ghost', 'Danger', 'Block') {
        if ($PSBoundParameters.ContainsKey($switchProperty)) {
            $descriptor[$switchProperty.Substring(0, 1).ToLowerInvariant() + $switchProperty.Substring(1)] = [bool]$PSBoundParameters[$switchProperty]
        }
    }

    if ($PSBoundParameters.ContainsKey('AutoInsertSpace')) {
        $descriptor.autoInsertSpace = $AutoInsertSpace
    }

    if ($PSBoundParameters.ContainsKey('Loading') -or $PSBoundParameters.ContainsKey('LoadingDelay') -or $PSBoundParameters.ContainsKey('LoadingIcon')) {
        if ($PSBoundParameters.ContainsKey('LoadingDelay') -or $PSBoundParameters.ContainsKey('LoadingIcon')) {
            $loadingDescriptor = @{}

            if ($PSBoundParameters.ContainsKey('LoadingDelay')) {
                $loadingDescriptor.delay = $LoadingDelay
            }

            if ($PSBoundParameters.ContainsKey('LoadingIcon')) {
                $loadingDescriptor.icon = $LoadingIcon
            }

            $descriptor.loading = $loadingDescriptor
        }
        else {
            $descriptor.loading = [bool]$Loading
        }
    }
    elseif ($PSBoundParameters.ContainsKey('Loading')) {
        $descriptor.loading = [bool]$Loading
    }

    if ($PSBoundParameters.ContainsKey('DataAttributes')) {
        $descriptor.dataAttributes = $DataAttributes
    }

    if ($PSBoundParameters.ContainsKey('Value')) {
        $descriptor.value = $Value
    }

    if ($null -ne $OnClick) {
        $descriptor.onClick = $OnClick
    }

    $descriptor
}

function New-AntDesignDemo {
    [CmdletBinding()]
    [OutputType([object[]])]
    param()

    @{
        type       = 'antd-docs'
        id         = 'antdesign-docs'
        title      = 'Ant Design Components'
        overview   = 'Component documentation for the PowerShell Universal Ant Design framework. The examples shown in the page are generated from the module command help so the docs and comment-based help stay aligned.'
        components = @(
            Get-AntDesignComponentDocumentation -Key 'button' -Title 'Button' -CommandName 'New-UDAntDesignButton' -SourceUrl 'https://ant.design/components/button/'
            Get-AntDesignComponentDocumentation -Key 'message' -Title 'Message' -CommandName 'Show-AntDesignMessage' -Category 'Feedback' -SourceUrl 'https://ant.design/components/message/'
        )
    }
}

function New-AntDesignDemoApp {
    [CmdletBinding()]
    param()

    if (-not (Get-Command -Name 'New-UDApp' -ErrorAction Ignore)) {
        throw 'New-AntDesignDemoApp requires PowerShell Universal and the Universal cmdlets to be loaded.'
    }

    New-UDApp -Title 'Ant Design Components' -Content {
        New-AntDesignDemo
    }
}

Export-ModuleMember -Function @(
    'Get-PSUAntDesignFrameworkAssetBasePath',
    'Get-PSUAntDesignFrameworkEntryPoint',
    'New-UDAntDesignText',
    'New-UDAntDesignButton',
    'Show-AntDesignMessage',
    'New-AntDesignDemo',
    'New-AntDesignDemoApp'
)
