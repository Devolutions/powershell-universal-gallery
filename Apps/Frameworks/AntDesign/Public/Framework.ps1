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