New-PSUEndpoint -Url "/cim/class" -Description "Return CIM classes. " -Method @('GET') -Endpoint {
    param($Namespace = "root/CIMV2")

    Get-CimClass -Namespace $Namespace | ForEach-Object {
        [PSCustomObject]@{
            ClassName      = $_.CimClassName
            SuperClassName = $_.CimSuperClassName
        }
    }
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/cim/instance/:className" -Description "Returns WMI class instances." -Method @('GET') -Endpoint {
    param($ClassName, $Filter, $Namespace, [string[]]$Property)

    $Parameters = @{
        ClassName = $ClassName
    }

    if ($Filter) {
        $Parameters["Filter"] = $Filter
    }

    if ($Property) {
        $Parameters["Property"] = $Property -split ','
    }

    if ($Namespace) {
        $Parameters["Namespace"] = $Namespace
    }

    Get-CimInstance @Parameters
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/cim/instance/:className" -Description "Creates a new CIM instance." -Method @('POST') -Endpoint {
    param(
        [Parameter(Mandatory)]
        $ClassName,
        [Parameter()]
        $Namespace
    )

    $Parameters = @{
        ClassName = $ClassName
    }

    if ($Namespace) {
        $Parameters["Namespace"] = $Namespace
    }

    $Property = $Body | ConvertFrom-Json -AsHashtable
    New-CimInstance @Parameters -Property $Property
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/cim/instance/:className" -Description "Update a CIM instance." -Method @('PUT') -Endpoint {
    param($ClassName, $Filter, $Namespace)

    $Parameters = @{
        ClassName = $ClassName
    }

    if ($Namespace) {
        $Parameters["Namespace"] = $Namespace
    }

    $Property = $Body | ConvertFrom-Json -AsHashtable

    $Instance = Get-CimInstance @Parameters -Filter $Filter
    Set-CimInstance -InputObject $Instance -Property $Property
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/cim/method/:className/:method" -Description "Invokes a CIM method. " -Method @('PUT') -Endpoint {
    param(
        [Parameter(Mandatory)]
        $ClassName, 
        [Parameter(Mandatory)]
        $Method, 
        [Parameter()]
        $Filter, 
        [Parameter()]
        $Namespace
    )

    $Arguments = @{}
    if ($Body) {
        $Arguments = @{
            Arguments = $Body | ConvertFrom-Json -AsHashtable
        }
    }

    if ($Namespace) {
        $Parameters["Namespace"] = $Namespace
    }

    if ($Filter) {
        $Instance = Get-CimInstance -Filter $Filter -ClassName $ClassName
        Invoke-CimMethod -InputObject $Instance -MethodName $Method @Arguments
    }
    else {
        Invoke-CimMethod -ClassName $ClassName -MethodName $Method @Arguments
    }
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/cim/namespace" -Description "Returns a list of namespaces on WMI. " -Method @('GET') -Endpoint {
    param(
        $Root = "Root"
    )

    # Source: https://gist.github.com/jdhitsolutions/3f98b8f31d423e5fee49279a20652707

    Function Get-CimNamespace {
        [cmdletbinding(DefaultParameterSetName = 'computer')]
        Param(
            [Parameter(Position = 0)]
            [ValidateNotNullorEmpty()]
            [string]$Namespace = $Root,
            [Parameter(ParameterSetName = 'computer')]
            [ValidateNotNullorEmpty()]
            [string]$Computername = $env:computername,
            [Parameter(ParameterSetName = 'computer')]
            [PSCredential]$Credential,
            [switch]$Recurse,
            [Parameter(ParameterSetName = 'session')]
            [CimSession]$CimSession
        )

        Write-Verbose "[$((Get-Date).timeOfDay)] Starting $($myinvocation.MyCommand)"    

        #private function to do the actual enumeration
        Function _EnumNamespace {
            [cmdletbinding(DefaultParameterSetName = 'computer')]
            Param(
                [Parameter(Position = 0)]
                [ValidateNotNullorEmpty()]
                [string]$Namespace = "Root",
                [Parameter(ParameterSetName = 'computer')]
                [ValidateNotNullorEmpty()]
                [string]$Computername = $env:computername,
                [Parameter(ParameterSetName = 'computer')]
                [PSCredential]$Credential,
                [switch]$Recurse,
                [Parameter(ParameterSetName = 'session')]
                [CimSession]$CimSession
            )
            Write-Verbose "[$((Get-Date).timeOfDay)] Starting $($myinvocation.MyCommand)"    

            #define parameter hashtable for Get-CimInstance
            $cimInst = @{
                Namespace = $Namespace
                ClassName = '__Namespace'
            }

            if ($pscmdlet.ParameterSetName -eq 'computer' -AND $Computername -ne $env:computername) {
                Write-Verbose "[$((Get-Date).timeOfDay)] Creating a CIMSession to $Computername" 
                $cimParams = @{
                    Erroraction  = 'stop'
                    Computername = $computername
                }   
                if ($Credential) {
                    Write-Verbose "[$((Get-Date).timeOfDay)] Using alternate credential for $($credential.username)"    
                    $cimParams.Add('Credential', $Credential)
                }
                #create a CIM Session
                Try {
                    $CimSession = New-CimSession @cimParams
                    #add to CimInstance hashtable
                    $cimInst.Add("cimsession", $CimSession)
                    #save a reference to this session so it can be removed later
                    $script:cs = $cimSession
                }
                Catch {
                    Throw $_
                }
            }
            elseif ($pscmdlet.ParameterSetName -eq 'session') {
                Write-Verbose "[$((Get-Date).timeOfDay)] Using CimSession" 
                $cimInst.Add("cimsession", $CimSession)
                #save a reference to this session so it can be removed later
                $script:cs = $cimSession
            }

            Write-Verbose "[$((Get-Date).timeOfDay)] Getting Namespaces"    

            $nspaces = Get-CimInstance @cimInst

            Write-Verbose "[$((Get-Date).timeOfDay)] Found $($nspaces.count) namespaces under $namespace"
            if ($nspaces.count -gt 0) {
                foreach ($nspace in $nspaces) {
                    Write-Verbose "[$((Get-Date).timeOfDay)] Processing $($nspace.name)"
                    $child = Join-Path -Path $Namespace -ChildPath $nspace.Name
                    [pscustomobject]@{
                        Computername = $nspace.cimsystemproperties.servername
                        Namespace    = $child
                    }
                    if ($recurse -and $CimSession) {
                        Write-Verbose "[$((Get-Date).timeOfDay)] Recursing and re-using cimsession" 
                        _EnumNamespace -namespace $child -Recurse -CimSession $cimSession
                    }
                    elseif ($recurse) {
                        Write-Verbose "[$((Get-Date).timeOfDay)] Recursing" 
                        _EnumNamespace -namespace $child -Recurse
                    }
                } #foreach
            } #if
            Write-Verbose "[$((Get-Date).timeOfDay)] Ending $($myinvocation.MyCommand)"
        } #close _EnumNamespace function

        #initiate the process
        _EnumNamespace @PSBoundParameters

        #clean-up
        if ($script:cs) {
            Write-Verbose "[$((Get-Date).timeOfDay)] Removing CIMSession"    
            $script:cs | Remove-CimSession
        }

        Write-Verbose "[$((Get-Date).timeOfDay)] Ending $($myinvocation.MyCommand)"    
    } #close main function

    Get-CimNamespace -Namespace $Root
} -Authentication -Role @('Administrator') 
New-PSUEndpoint -Url "/cmi/instance/:className" -Description "Removes a CIM instance based on a query." -Method @('DELETE') -Endpoint {
    param(
        [Parameter(Mandatory)]
        $ClassName,
        [Parameter()]
        $Namespace,
        [Parameter(Mandatory)]
        $Filter
    )

    $Parameters = @{
        ClassName = $ClassName
        Filter    = $Filter
    }

    if ($Namespace) {
        $Parameters["Namespace"] = $Namespace
    }

    Remove-CimInstance @Parameters
} -Authentication -Role @('Administrator')