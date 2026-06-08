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
    Creates an antd-button descriptor that maps the PowerShell command surface to the core Ant Design Button TypeScript definition used by the client runtime.

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
    # Primary button
    New-UDAntDesignButton -Text 'Primary action' -Type primary

    Creates a primary Ant Design button using the legacy type shortcut.

    .EXAMPLE
    # Destructive block button
    New-UDAntDesignButton -Text 'Delete account' -Color danger -Variant solid -Danger -Block

    Creates a full-width destructive action button.

    .EXAMPLE
    # Link button
    New-UDAntDesignButton -Text 'Open Ant Design' -Type link -Href 'https://ant.design/components/button/'

    Creates a button that renders as a link.

    .EXAMPLE
    # Loading round button
    New-UDAntDesignButton -Text 'Loading' -Shape round -Loading -Size large

    Creates a rounded loading button.

    .EXAMPLE
    # Icon button
    New-UDAntDesignButton -Text 'Download' -Type primary -Icon 'DownloadOutlined' -IconPosition end

    Creates a primary button that renders an Ant Design icon.
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
    'New-AntDesignDemo',
    'New-AntDesignDemoApp'
)
