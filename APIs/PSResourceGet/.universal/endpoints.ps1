New-PSUEndpoint -Url "/psresourceget/module" -Description "Returns modules installed by PSResourceGet. " -Method @('GET') -Endpoint {
    param($Name, $Version, $Path, $Scope)

    $Parameters = @{}

    if ($Name) {
        $Parameters["Name"] = $Name
    }

    if ($Version) {
        $Parameters["Version"] = $Version
    }

    if ($Path) {
        $Parameters["Path"] = $Path
    }

    if ($Scope) {
        $Parameters["Scope"] = $Scope
    }

    Get-PSResource @Parameters | Select-Object Name, Version, Prerelease, Repository, Description
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/psresourceget/module" -Description "Installs a new resource." -Method @('POST') -Endpoint {
    param(
        $Name,
        $Version,
        $Repository,
        [ValidateSet("CurrentUser", "AllUsers")]
        $Scope)

    $Parameters = @{}

    if ($Name) {
        $Parameters["Name"] = $Name
    }

    if ($Version) {
        $Parameters["Version"] = $Version
    }

    if ($Repository) {
        $Parameters["Repository"] = $Repository
    }

    if ($Scope) {
        $Parameters["Scope"] = $Scope
    }

    Install-PSResource @Parameters -PassThru | Select-Object Name, Version
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/psresourceget/module/:name" -Description "Find a resource from the registered repositories." -Method @('GET') -Endpoint {
    param(
        [Parameter(Mandatory)]
        $Name,
        [Parameter()]
        $Repository,
        [Parameter()]
        [ValidateSet("Module", "Script", "Nupkg")]
        $Type
    )

    $OptionalParameters = @{}

    if ($Repository) {
        $OptionalParameters["Repository"] = $Repository
    }

    if ($Type) {
        $OptionalParameters["Type"] = $Type
    }

    Find-PSResource -Name $Name @OptionalParameters
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/psresourceget/module/:name" -Description "Uninstalls a PSResource." -Method @('DELETE') -Endpoint {
    param(
        [Parameter(Mandatory)]
        $Name
    )

    Uninstall-PSResource -Name $Name
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/psresourceget/repository" -Description "Returns registered resource repositories." -Method @('GET') -Endpoint {
    param($Name)

    $Parameters = @{}

    if ($Name) {
        $Parameters["Name"] = $Name
    }

    Get-PSResourceRepository @Parameters
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/psresourceget/repository" -Description "Registers a new resource repository." -Method @('POST') -Endpoint {
    param(
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        $Uri,
        [Parameter()]
        [bool]$Trusted
    )

    $Parameters = @{
        Name = $Name 
        Uri  = $Uri
    }

    if ($Trusted) {
        $Parameters["Trusted"] = $true
    }

    Register-PSResourceRepository @Pawrameters
} -Authentication -Role @('Administrator')