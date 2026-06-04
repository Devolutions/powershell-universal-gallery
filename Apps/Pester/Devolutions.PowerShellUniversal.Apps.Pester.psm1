function Import-TestData {
    param($Path)

    # Load the XML content
    [xml]$xmlContent = Get-Content -Path $Path

    # Function to process test-case nodes into PSCustomObjects
    function Import-TestCase {
        param (
            $testCaseNode
        )
        [PSCustomObject]@{
            Name           = $testCaseNode.name
            Description    = $testCaseNode.description
            Time           = $testCaseNode.time
            Asserts        = $testCaseNode.asserts
            Success        = [bool]$testCaseNode.success
            Result         = $testCaseNode.result
            Executed       = [bool]$testCaseNode.executed
            FailureMessage = $testCaseNode.failure.message
            StackTrace     = $testCaseNode.failure."stack-trace".InnerText
        }
    }

    # Function to recursively process test-suite nodes into hierarchical PSCustomObjects
    function Import-TestSuite {
        param (
            $suiteNode
        )

        # Import the test cases in the current suite
        $testCases = foreach ($testCase in $suiteNode.results.'test-case') {
            Import-TestCase -testCaseNode $testCase
        }

        # Import the child test suites
        $childSuites = foreach ($childSuite in $suiteNode.results.'test-suite') {
            
            Import-TestSuite -suiteNode $childSuite
        }

        # Create the PSCustomObject for the current suite
        [PSCustomObject]@{
            Name        = $suiteNode.name
            Type        = $suiteNode.type
            Description = $suiteNode.description
            Executed    = [bool]$suiteNode.executed
            Result      = $suiteNode.result
            Success     = [bool]$suiteNode.success
            Time        = $suiteNode.time
            Asserts     = $suiteNode.asserts
            TestCases   = $testCases
            ChildSuites = $childSuites
        }
    }

    # Extract environment information
    $environmentInfo = [PSCustomObject]@{
        NUnitVersion = $xmlContent."test-results".environment.'nunit-version'
        UserDomain   = $xmlContent."test-results".environment.'user-domain'
        OSVersion    = $xmlContent."test-results".environment.'os-version'
        CLRVersion   = $xmlContent."test-results".environment.'clr-version'
        Platform     = $xmlContent."test-results".environment.platform
        CWD          = $xmlContent."test-results".environment.cwd
        MachineName  = $xmlContent."test-results".environment.'machine-name'
        User         = $xmlContent."test-results".environment.user
    }

    $DateTime = [DateTime]"$($xmlContent."test-results".date) $($xmlContent."test-results".time)"

    [PSCustomObject]@{
        path            = $Path
        total           = [int]$xmlContent."test-results".total
        errors          = [int]$xmlContent."test-results".errors
        failures        = [int]$xmlContent."test-results".failures
        notRun          = [int]$xmlContent."test-results".'not-run'
        ignored         = [int]$xmlContent."test-results".'ignored'
        skipped         = [int]$xmlContent."test-results".skipped
        invalid         = [int]$xmlContent."test-results".invalid
        timestamp       = $DateTime

        EnvironmentInfo = $environmentInfo
        TestSuite       = Import-TestSuite -suiteNode $xmlContent."test-results".'test-suite'
    }
}

function New-UDPesterCountBadge {
    param($Count, $Icon, $Text, $Color = "Primary")

    New-UDChip -Icon (New-UDIcon -Icon $Icon ) -Label "$Text ($Count)" -Color $Color -Style @{ marginRight = "10px"; marginBottom = '10px' }
}

function New-UDTestResultIcon {
    param($Result)

    New-UDTooltip -TooltipContent { $Result } -Content {
        if ($Result -eq 'Success') {
            New-UDIcon -Icon "CircleCheck" -Color green 
        }
        elseif ($Result -eq 'Failure') {
            New-UDIcon -Icon "TimesCircle" -Color red
        }
        else {
            New-UDIcon -Icon "CircleExclamation" -Color yellow
        }
    }
}

function New-UDTestSuiteTable {
    param($TestSuite, [Switch]$Active)

    if ($TestSuite.Result -eq 'Success') {
        $Icon = New-UDIcon -Icon "CircleCheck" -Color green -Size '2x' -Style @{ marginRight = '10px' }
    }
    elseif ($TestSuite.Result -eq 'Failure') {
        $Icon = New-UDIcon -Icon "TimesCircle" -Color red -Size '2x' -Style @{ marginRight = '10px' }
    }
    else {
        $Icon = New-UDIcon -Icon "CircleExclamation" -Color yellow -Size '2x' -Style @{ marginRight = '10px' }
    }

    New-UDExpansionPanelGroup -Children {
        New-UDExpansionPanel -Title $TestSuite.Name -Icon $Icon -Active:$Active -Children {
            New-UDChip -Icon (New-UDIcon -Icon Clock) -Label $TestSuite.Time -Style @{
                marginBottom = '10px'
            }

            New-UDDivider

            if ($TestSuite.TestCases.Count -gt 0) {
                New-UDExpansionPanelGroup -Children {
                    New-UDExpansionPanel -Title "Test Cases ($($TestSuite.TestCases.Count))" -Children {
                        New-UDTestCaseTable -TestSuite $TestSuite
                    } -Icon (New-UDIcon -Icon 'Flask' -Size '2x' -Style @{ marginRight = '10px' })
                }
            }

            $TestSuite.ChildSuites | ForEach-Object {
                New-UDTestSuiteTable -TestSuite $_
            }
        }
    }

}

function Get-TestCase {
    [CmdletBinding()]
    param($TestSuite, [Switch]$Recursive)

    $TestSuite.TestCases | ForEach-Object {
        Write-Output $_
    }

    if ($Recursive) {
        foreach ($Child in $TestSuite.ChildSuites) {
            Get-TestCase -TestSuite $Child -Recursive
        }
    }
}

function New-UDTestCaseTable {
    param($TestSuite, [Switch]$Recursive)

    $TestCases = Get-TestCase $TestSuite -Recursive:$Recursive

    New-UDTable -Data $TestCases -Columns @(
        New-UDTableColumn -Property Result -OnRender {
            New-UDTestResultIcon -Result $EventData.Result
        } -ShowSort -IncludeInExport -IncludeInSearch
        New-UDTableColumn -Property Name -ShowSort -IncludeInExport -IncludeInSearch
        New-UDTableColumn -Property Description -ShowSort -IncludeInExport -IncludeInSearch
        New-UDTableColumn -Property Time -Title 'Execution Time' -ShowSort -IncludeInExport -IncludeInSearch
    ) -ShowSort -ShowExport -ShowSearch -ShowPagination -Dense -PageSize 25
}

function New-UDPesterApp {
    $PesterTestResultDirectory = "$Repository\TestResults"

    $Pages = @()
    $TestResults = @()
    
    if (Test-Path $PesterTestResultDirectory) {
        $TestData = Get-ChildItem -Path $PesterTestResultDirectory
    }
    
    foreach ($TestResult in $TestData) {
        $TestResultObject = Import-TestData -Path $TestResult.FullName
        $TestResults += $TestResultObject
    
        $Pages += New-UDPage -Title "Test Result | $($TestResult.Name)" -Url "/results/$($TestResult.Name.Replace('.xml', ''))" -Content {
            New-UDChip -Icon (New-UDIcon -Icon 'Calendar') -Label ($TestResultObject.Timestamp) -Style @{ marginBottom = '10px'; marginRight = '10px' }
            New-UDChip -Icon (New-UDIcon -Icon 'Server') -Label ($TestResultObject.EnvironmentInfo.UserDomain) -Style @{ marginBottom = '10px'; marginRight = '10px' }
            New-UDChip -Icon (New-UDIcon -Icon 'User') -Label ($TestResultObject.EnvironmentInfo.User) -Style @{ marginBottom = '10px'; marginRight = '10px' }
            New-UDChip -Icon (New-UDIcon -Icon 'Computer') -Label ($TestResultObject.EnvironmentInfo.MachineName) -Style @{ marginBottom = '10px'; marginRight = '10px' }
    
            New-UDPesterCountBadge -Count $TestResultObject.Total -Text "Total" -Icon "List"
            New-UDPesterCountBadge -Count $TestResultObject.Errors -Text "Errors" -Icon "CircleExclamation" -Color Error
            New-UDPesterCountBadge -Count $TestResultObject.Failures -Text "Failures" -Icon "TimesCircle" -Color Error
            New-UDPesterCountBadge -Count $TestResultObject.Skipped -Text "Skipped" -Icon "Forward" -Color Warning
            New-UDPesterCountBadge -Count $TestResultObject.Ignored -Text "Ignored" -Icon "EyeSlash" -Color Secondary
            New-UDPesterCountBadge -Count $TestResultObject.Invalid -Text "Invalid" -Icon "TriangleExclamation" -Color Warning
    
            New-UDTabs -Tabs {
                New-UDTab -Text 'Test Cases' -Icon (New-UDIcon -Icon 'Flask' -Size '2x' -Style @{ marginRight = '10px' }) -Content {
                    New-UDTestCaseTable -TestSuite $TestResultObject.TestSuite -Recursive
                }
                New-UDTab -Text 'Test Suites' -Icon (New-UDIcon -Icon 'Cubes' -Size '2x' -Style @{ marginRight = '10px' }) -Content {
                    New-UDTestSuiteTable -TestSuite $TestResultObject.TestSuite -Active
                }
            }
        }
    }
    
    $Pages += New-UDPage -Name 'Test Results' -Url "/home" -Content {
        New-UDTable -Data $TestResults -Columns @(
            New-UDTableColumn -Property View -OnRender {
                $Name = (Split-Path $EventData.Path -Leaf).Replace(".xml", "")
                New-UDButton -Icon (New-UDIcon -Icon 'View') -Text "View" -Href "results/$Name" -Target "_blank"
            }
            New-UDTableColumn -Property Timestamp -OnRender {
                New-UDDateTime -InputObject $EventData.Timestamp
            }
            New-UDTableColumn -Property Results -OnRender {
                New-UDPesterCountBadge -Count $EventData.Total -Text "Total" -Icon "List"
                New-UDPesterCountBadge -Count $EventData.Errors -Text "Errors" -Icon "CircleExclamation" -Color Error
                New-UDPesterCountBadge -Count $EventData.Failures -Text "Failures" -Icon "TimesCircle" -Color Error
                New-UDPesterCountBadge -Count $EventData.Skipped -Text "Skipped" -Icon "Forward" -Color Warning
                New-UDPesterCountBadge -Count $EventData.Ignored -Text "Ignored" -Icon "EyeSlash" -Color Secondary
                New-UDPesterCountBadge -Count $EventData.Invalid -Text "Invalid" -Icon "TriangleExclamation" -Color Warning
            }
        )
    }
    
    New-UDApp -Pages $Pages
}

function Invoke-PSUPesterTest {
    Invoke-Pester -OutputFile "$Repository\TestResults\Test$($UAJob.Id).xml" -OutputFormat NUnitXml
    Get-PSUApp -Name 'Test Viewer' -Integrated | Stop-PSUApp -Integrated
    Get-PSUApp -Name 'Test Viewer' -Integrated | Start-PSUApp -Integrated
}