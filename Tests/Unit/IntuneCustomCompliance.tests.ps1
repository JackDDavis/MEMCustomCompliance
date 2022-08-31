param()

$rootPath = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$moduleName = 'IntuneCustomCompliance'
$intuneModule = (Join-Path $rootPath "IntuneCustomCompliance\$moduleName.psm1")
Import-Module -Name $intuneModule

try {
    InModuleScope IntuneCustomCompliance {
        Describe 'New-IntuneCustomComplianceSetting' -Tag 'ComplianceSetting' {
            BeforeAll {
                New-Item "TestDrive:\test.json"

                $nonConvert = @{
                    SettingName = 'Fake Firewall Policy'
                    Operator    = 'IsEquals'
                    dataType    = 'String'
                    Operand     = 'Blocked'
                    MoreInfoURL = "https://bing.com"
                    Title       = 'this is the title'
                    Description = 'this is my description'
                }

                $convert = @{
                    SettingName = 'Fake Firewall Policy'
                    Operator    = 'IsEquals'
                    dataType    = 'String'
                    Operand     = 'Blocked'
                    MoreInfoURL = "https://bing.com"
                    Title       = 'this is the title'
                    Description = 'this is my description'
                    Convert     = $true
                }

                $nonConvertDestination = @{
                    SettingName = 'Fake Firewall Policy'
                    Operator    = 'IsEquals'
                    dataType    = 'String'
                    Operand     = 'Blocked'
                    MoreInfoURL = "https://bing.com"
                    Title       = 'this is the title'
                    Description = 'this is my description'
                    Destination = (Get-Item -Path TestDrive:\test.json).FullName
                }

                $convertDestination = @{
                    SettingName = 'Fake Firewall Policy'
                    Operator    = 'IsEquals'
                    dataType    = 'String'
                    Operand     = 'Blocked'
                    MoreInfoURL = "https://bing.com"
                    Title       = 'this is the title'
                    Description = 'this is my description'
                    Convert     = $true
                    Destination = (Get-Item -Path TestDrive:\test.json).FullName
                }

                $operandFalse = @{
                    SettingName = 'Fake Firewall Policy'
                    Operator    = 'IsEquals'
                    dataType    = 'Boolean'
                    Operand     = "False"
                    MoreInfoURL = "https://bing.com"
                    Title       = 'this is the title'
                    Description = 'this is my description'
                    Convert     = $true
                    Destination = (Get-Item -Path TestDrive:\test.json).FullName
                }

                $operandTrue = @{
                    SettingName = 'Fake Firewall Policy'
                    Operator    = 'IsEquals'
                    dataType    = 'Boolean'
                    Operand     = "True"
                    MoreInfoURL = "https://bing.com"
                    Title       = 'this is the title'
                    Description = 'this is my description'
                    Convert     = $true
                    Destination = (Get-Item -Path TestDrive:\test.json).FullName
                }
            }

            Context 'Should return desired results' {

                It 'Should return Ordered Dictionary with desired results' {
                    $result = New-IntuneCustomComplianceSetting @nonConvert
                    $result                                | Should -BeOfType System.Collections.Specialized.OrderedDictionary
                    $result.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $result.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $result.DataType                       | Should -Be -ExpectedValue 'String'
                    $result.Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $result.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $result.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $result.RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $result.RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }

                It 'Should return json string with desired results' {
                    $result = New-IntuneCustomComplianceSetting @convert
                    $result                                | Should -BeOfType String
                    $validate = $result | ConvertFrom-Json
                    $validate.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $validate.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $validate.DataType                       | Should -Be -ExpectedValue 'String'
                    $validate.Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $validate.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $validate.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $validate.RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $validate.RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }
            }

            Context 'Should return desired results with destination specified' {

                It 'Should return Ordered Dictionary with desired results' {
                    $result = New-IntuneCustomComplianceSetting @nonConvertDestination
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $result                                | Should -BeOfType System.Collections.Specialized.OrderedDictionary
                    $result.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $result.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $result.DataType                       | Should -Be -ExpectedValue 'String'
                    $result.Operand                            | Should -Be -ExpectedValue 'Blocked'
                    $result.MoreInfoURL                        | Should -Be -ExpectedValue 'https://bing.com'
                    $result.RemediationStrings.Language        | Should -Be -ExpectedValue 'en_US'
                    $result.RemediationStrings.Title           | Should -Be -ExpectedValue 'this is the title'
                    $result.RemediationStrings.Description     | Should -Be -ExpectedValue 'this is my description'
                    $test.Rules.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $test.Rules.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules.DataType                       | Should -Be -ExpectedValue 'String'
                    $test.Rules.Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $test.Rules.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules.RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $test.Rules.RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }

                It 'Should return json string with desired results' {
                    $result = New-IntuneCustomComplianceSetting @convertDestination
                    $result                                          | Should -BeOfType String
                    $validate = $result                              | ConvertFrom-Json
                    $validate.SettingName                            | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $validate.Operator                               | Should -Be -ExpectedValue 'IsEquals'
                    $validate.DataType                               | Should -Be -ExpectedValue 'String'
                    $validate.Operand                                | Should -Be -ExpectedValue 'Blocked'
                    $validate.MoreInfoURL                            | Should -Be -ExpectedValue 'https://bing.com'
                    $validate.RemediationStrings.Language            | Should -Be -ExpectedValue 'en_US'
                    $validate.RemediationStrings.Title               | Should -Be -ExpectedValue 'this is the title'
                    $validate.RemediationStrings.Description         | Should -Be -ExpectedValue 'this is my description'
                }

                It 'Should return json string with desired results changing Operand to false' {
                    $result = New-IntuneCustomComplianceSetting @operandFalse
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $result                                | Should -BeOfType String
                    $validate = $result | ConvertFrom-Json
                    $validate.SettingName                      | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $validate.Operator                         | Should -Be -ExpectedValue 'IsEquals'
                    $validate.DataType                         | Should -Be -ExpectedValue 'Boolean'
                    $validate.Operand                          | Should -Be -ExpectedValue 'false'
                    $validate.MoreInfoURL                      | Should -Be -ExpectedValue 'https://bing.com'
                    $validate.RemediationStrings.Language      | Should -Be -ExpectedValue 'en_US'
                    $validate.RemediationStrings.Title         | Should -Be -ExpectedValue 'this is the title'
                    $validate.RemediationStrings.Description   | Should -Be -ExpectedValue 'this is my description'
                    $test.Rules.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $test.Rules.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules.DataType                       | Should -Be -ExpectedValue 'Boolean'
                    $test.Rules.Operand                        | Should -Be -ExpectedValue 'false'
                    $test.Rules.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules.RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $test.Rules.RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }

                It 'Should return json string with desired results changing Operand to true' {
                    $result = New-IntuneCustomComplianceSetting @operandTrue
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $validate = $result | ConvertFrom-Json
                    $result                                    | Should -BeOfType String
                    $validate.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $validate.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $validate.DataType                       | Should -Be -ExpectedValue 'Boolean'
                    $validate.Operand                        | Should -Be -ExpectedValue 'true'
                    $validate.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $validate.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $validate.RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $validate.RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                    $test.Rules.SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $test.Rules.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules.DataType                       | Should -Be -ExpectedValue 'Boolean'
                    $test.Rules.Operand                        | Should -Be -ExpectedValue 'true'
                    $test.Rules.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules.RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $test.Rules.RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }
            }

            Context 'Should throw' {
                BeforeEach {
                    New-Item "TestDrive:\test.txt"
                    $nonConvertDestinationText = @{
                        SettingName = 'Fake Firewall Policy'
                        Operator    = 'IsEquals'
                        dataType    = 'String'
                        Operand     = 'Blocked'
                        MoreInfoURL = "https://bing.com"
                        Title       = 'this is the title'
                        Description = 'this is my description'
                        Destination = (Get-Item -Path TestDrive:\test.txt).FullName
                    }

                    $destInvalid = "Cannot validate argument on parameter 'Destination'. Export must be JSON format"
                }

                It 'Should throw when destination is not specified as Json' {
                    { New-IntuneCustomComplianceSetting @nonConvertDestinationText } | Should -Throw -ExpectedMessage $destInvalid
                }
            }
        }
        Describe 'New-IntuneCustomComplianceRuleSet' -Tag 'ComplianceRuleSet' {
            BeforeAll {
                New-Item "TestDrive:\test.json"

                $queryFWRules = @(
                    @{
                        Name   = 'RemoteAssistance-In-TCP-EdgeScope'
                        Action = 'Allow'
                    }
                    @{
                        Name   = 'RemoteAssistance-In-TCP-EdgeScope-Active'
                        Action = 'Allow'
                    }
                )

                $queryFwRule = @{
                    Name   = 'RemoteAssistance-In-TCP-EdgeScope-Active'
                    Action = 'Allow'
                }

                $queryRulesInput = @{
                    QueryResult   = $queryFWRules
                    PropertyName  = 'Name'
                    PropertyValue = 'Action'
                    Operator      = 'IsEquals'
                    DataType      = 'String'
                    MoreInfoURL   = 'https://bing.com'
                    Title         = 'FW'
                    Description   = 'Test description'
                    Destination   = (Get-Item -Path TestDrive:\test.json).FullName
                }

                $queryRuleInput = @{
                    QueryResult   = $queryFWRule
                    PropertyName  = 'Name'
                    PropertyValue = 'Action'
                    Operator      = 'IsEquals'
                    DataType      = 'String'
                    MoreInfoURL   = 'https://bing.com'
                    Title         = 'FW'
                    Description   = 'Test description'
                    Destination   = (Get-Item -Path TestDrive:\test.json).FullName
                }

                $queryRuleInputNoDestination = @{
                    QueryResult   = $queryFWRule
                    PropertyName  = 'Name'
                    PropertyValue = 'Action'
                    Operator      = 'IsEquals'
                    DataType      = 'String'
                    MoreInfoURL   = 'https://bing.com'
                    Title         = 'FW'
                    Description   = 'Test description'
                }
            }

            Context 'Should return desired results' {

                It 'Should return desired results for an array of actions' {
                    New-IntuneCustomComplianceRuleSet @queryRulesInput
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $test.Rules[0].SettingName                       | Should -Be -ExpectedValue 'RemoteAssistance-In-TCP-EdgeScope'
                    $test.Rules[0].Operator                          | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[0].DataType                          | Should -Be -ExpectedValue 'String'
                    $test.Rules[0].Operand                           | Should -Be -ExpectedValue 'Allow'
                    $test.Rules[0].MoreInfoURL                       | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[0].RemediationStrings.Language       | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[0].RemediationStrings.Title          | Should -Be -ExpectedValue 'FW'
                    $test.Rules[0].RemediationStrings.Description    | Should -Be -ExpectedValue 'Test description'
                    $test.Rules[1].SettingName                       | Should -Be -ExpectedValue 'RemoteAssistance-In-TCP-EdgeScope-Active'
                    $test.Rules[1].Operator                          | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[1].DataType                          | Should -Be -ExpectedValue 'String'
                    $test.Rules[1].Operand                           | Should -Be -ExpectedValue 'Allow'
                    $test.Rules[1].MoreInfoURL                       | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[1].RemediationStrings.Language       | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[1].RemediationStrings.Title          | Should -Be -ExpectedValue 'FW'
                    $test.Rules[1].RemediationStrings.Description    | Should -Be -ExpectedValue 'Test description'
                }

                It 'Should return desired results for single action' {
                    New-IntuneCustomComplianceRuleSet @queryRuleInput
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $test.Rules[0].SettingName                       | Should -Be -ExpectedValue 'RemoteAssistance-In-TCP-EdgeScope-Active'
                    $test.Rules[0].Operator                          | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[0].DataType                          | Should -Be -ExpectedValue 'String'
                    $test.Rules[0].Operand                           | Should -Be -ExpectedValue 'Allow'
                    $test.Rules[0].MoreInfoURL                       | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[0].RemediationStrings.Language       | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[0].RemediationStrings.Title          | Should -Be -ExpectedValue 'FW'
                    $test.Rules[0].RemediationStrings.Description    | Should -Be -ExpectedValue 'Test description'
                }

                It 'Should return desired results for single action' {
                    $result = New-IntuneCustomComplianceRuleSet @queryRuleInputNoDestination
                    $result                                | Should -BeOfType System.Collections.Specialized.OrderedDictionary
                    $result.SettingName                    | Should -Be -ExpectedValue 'RemoteAssistance-In-TCP-EdgeScope-Active'
                    $result.Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $result.DataType                       | Should -Be -ExpectedValue 'String'
                    $result.Operand                        | Should -Be -ExpectedValue 'Allow'
                    $result.MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $result.RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $result.RemediationStrings.Title       | Should -Be -ExpectedValue 'FW'
                    $result.RemediationStrings.Description | Should -Be -ExpectedValue 'Test description'
                }
            }

            Context 'Should throw' {
                BeforeEach {
                    New-Item "TestDrive:\test.txt"

                    $queryRuleInputBadDestination = @{
                        QueryResult   = $queryFWRule
                        PropertyName  = 'Name'
                        PropertyValue = 'Action'
                        Operator      = 'IsEquals'
                        DataType      = 'String'
                        MoreInfoURL   = 'https://bing.com'
                        Title         = 'FW'
                        Description   = 'Test description'
                        Destination   = (Get-Item -Path TestDrive:\test.txt).FullName
                    }

                    $destInvalid = "Cannot validate argument on parameter 'Destination'. Export must be JSON format"
                }

                It 'Should throw when destination is not specified as Json' {
                    { New-IntuneCustomComplianceRuleSet @queryRuleInputBadDestination } | Should -Throw -ExpectedMessage $destInvalid
                }
            }
        }
    }
}
finally {
    Remove-Module -Name $moduleName
}
