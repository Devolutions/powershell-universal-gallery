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

function New-UDAntDesignButton {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string]$Id = ([guid]::NewGuid().ToString()),
        [Parameter(Mandatory)]
        [string]$Text,
        [object]$OnClick,
        [object]$Value
    )

    if ($null -ne $OnClick -and $OnClick.PSObject.Methods.Name -contains 'Register') {
        $OnClick.Register($Id, $PSCmdlet)
    }

    $descriptor = @{
        type = 'antd-button'
        id   = $Id
        text = $Text
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

    @(
        New-UDAntDesignText -Id 'antdesign-demo-intro' -Text 'Ant Design framework demo for PowerShell Universal.'
        New-UDAntDesignText -Id 'antdesign-demo-summary' -Text 'This content uses the custom antd-text and antd-button descriptor types exposed by the framework module.'
        New-UDAntDesignButton -Id 'antdesign-demo-primary' -Text 'Show toast' -Value 'show-toast' -OnClick {
            Show-UDToast -Message 'Ant Design demo button clicked.'
        }
        New-UDAntDesignButton -Id 'antdesign-demo-secondary' -Text 'Refresh demo' -Value 'refresh-demo' -OnClick {
            Show-UDToast -Message 'Refresh the custom shell to pick up descriptor changes.'
        }
    )
}

function New-AntDesignDemoApp {
    [CmdletBinding()]
    param()

    if (-not (Get-Command -Name 'New-UDApp' -ErrorAction Ignore)) {
        throw 'New-AntDesignDemoApp requires PowerShell Universal and the Universal cmdlets to be loaded.'
    }

    New-UDApp -Title 'Ant Design Demo' -Content {
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
