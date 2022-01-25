param()

$rootPath = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$moduleName = 'IntuneCustomCompliance'
$intuneModule = (Join-Path $rootPath "IntuneCustomCompliance\$moduleName.psm1")
Import-Module -Name $intuneModule

try {
    InModuleScope IntuneCustomCompliance {
        Describe 'New-IntuneCustomComplianceSetting' -Tag 'ComplianceSetting' {
            BeforeAll {
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
        }
        Describe 'New-IntuneCustomComplianceRuleSet' -Tag 'ComplianceRuleSet' {
            BeforeAll {
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
                    QueryResult = $queryFWRules
                    sKeyName    = 'Name'
                    sValueName  = 'Action'
                    Operator    = 'IsEquals'
                    DataType    = 'String'
                    MoreInfoURL = 'https://bing.com'
                    Title       = 'FW'
                    Description = 'Test description'
                }

                $queryRuleInput = @{
                    QueryResult = $queryFWRule
                    sKeyName    = 'Name'
                    sValueName  = 'Action'
                    Operator    = 'IsEquals'
                    DataType    = 'String'
                    MoreInfoURL = 'https://bing.com'
                    Title       = 'FW'
                    Description = 'Test description'
                }
            }

            Context 'Should return desired results' {

                It 'Should return desired results for an array of actions' {
                    $result = New-IntuneCustomComplianceRuleSet @queryRulesInput
                    $result                                   | Should -BeOfType System.Collections.Specialized.OrderedDictionary
                    $result[0].SettingName                    | Should -Be -ExpectedValue 'RemoteAssistance-In-TCP-EdgeScope'
                    $result[0].Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $result[0].DataType                       | Should -Be -ExpectedValue 'String'
                    $result[0].Operand                        | Should -Be -ExpectedValue 'Allow'
                    $result[0].MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $result[0].RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $result[0].RemediationStrings.Title       | Should -Be -ExpectedValue 'FW'
                    $result[0].RemediationStrings.Description | Should -Be -ExpectedValue 'Test description'
                    $result[1].SettingName                    | Should -Be -ExpectedValue 'RemoteAssistance-In-TCP-EdgeScope-Active'
                    $result[1].Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $result[1].DataType                       | Should -Be -ExpectedValue 'String'
                    $result[1].Operand                        | Should -Be -ExpectedValue 'Allow'
                    $result[1].MoreInfoURL                    | Should -Be -ExpectedValue 'https://bing.com'
                    $result[1].RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $result[1].RemediationStrings.Title       | Should -Be -ExpectedValue 'FW'
                    $result[1].RemediationStrings.Description | Should -Be -ExpectedValue 'Test description'
                }

                It 'Should return desired results for single action' {
                    $result = New-IntuneCustomComplianceRuleSet @queryRuleInput
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
        }

        Describe 'Export-IntuneCustomComplianceRule' -Tag 'Export' {
            BeforeAll {
                New-Item "TestDrive:\test.json"
                New-Item "TestDrive:\nonjson.txt"
            }

            Context 'Should return desired results for ordered dictionary' {
                BeforeEach {
                    $ordered = @{
                        Setting = [ordered]@{
                            SettingName = 'Fake Firewall Policy'
                            Operator    = 'IsEquals'
                            DataType    = 'String'
                            Operand     = 'Blocked'
                            MoreInfoUrl = 'https://bing.com'
                            RemediationStrings = @(
                                [ordered]@{
                                    Language    = 'en_US'
                                    Title       = 'this is a title'
                                    Description = 'This is my description'
                                }
                            )
                        }
                        Destination = (Get-Item -Path TestDrive:\test.json).FullName
                    }
                }

                It 'Should return Ordered Dictionary with desired results' {
                    Export-IntuneCustomComplianceRule @ordered
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $test.Rules[0].SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $test.Rules[0].Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[0].DataType                       | Should -Be -ExpectedValue 'String'
                    $test.Rules[0].Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $test.Rules[0].MoreInfoUrl                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[0].RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[0].RemediationStrings.Title       | Should -Be -ExpectedValue 'this is a title'
                    $test.Rules[0].RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }
            }

            Context 'Should return desired results for an array' {
                BeforeEach {
                    $arrayofOrders = @{
                        Setting = @(
                            [ordered]@{
                                SettingName = 'Fake Firewall Policy'
                                Operator    = 'IsEquals'
                                DataType    = 'String'
                                Operand     = 'Blocked'
                                MoreInfoUrl = 'https://bing.com'
                                RemediationStrings = @(
                                    [ordered]@{
                                        Language    = 'en_US'
                                        Title       = 'this is a title'
                                        Description = 'This is my description'
                                    }
                                )
                            }
                            [ordered]@{
                                SettingName = 'Fake Firewall Block'
                                Operator    = 'IsEquals'
                                DataType    = 'String'
                                Operand     = 'Blocked'
                                MoreInfoUrl = 'https://bing.com'
                                RemediationStrings = @(
                                    [ordered]@{
                                        Language    = 'en_US'
                                        Title       = 'Block Title'
                                        Description = 'This is my block description'
                                    }
                                )
                            }
                        )
                        Destination = (Get-Item -Path TestDrive:\test.json).FullName
                    }
                }

                It 'Should return Ordered Dictionary with desired results' {
                    Export-IntuneCustomComplianceRule @arrayofOrders
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $test.Rules[0].SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $test.Rules[0].Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[0].DataType                       | Should -Be -ExpectedValue 'String'
                    $test.Rules[0].Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $test.Rules[0].MoreInfoUrl                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[0].RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[0].RemediationStrings.Title       | Should -Be -ExpectedValue 'this is a title'
                    $test.Rules[0].RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                    $test.Rules[1].SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Block'
                    $test.Rules[1].Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[1].DataType                       | Should -Be -ExpectedValue 'String'
                    $test.Rules[1].Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $test.Rules[1].MoreInfoUrl                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[1].RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[1].RemediationStrings.Title       | Should -Be -ExpectedValue 'Block title'
                    $test.Rules[1].RemediationStrings.Description | Should -Be -ExpectedValue 'This is my block description'
                }
            }

            Context 'Should return desired results for string' {
                BeforeEach {
                    $jsonImport = @{
                        Setting = '{
                            "SettingName":  "Fake Firewall Policy",
                            "Operator":  "IsEquals",
                            "DataType":  "String",
                            "Operand":  "Blocked",
                            "MoreInfoURL":  "https://bing.com",
                            "RemediationStrings":  [
                                                       {
                                                           "Language":  "en_US",
                                                           "Title":  "this is the title",
                                                           "Description":  "this is my description"
                                                       }
                                                   ]
                        }'
                        Destination = (Get-Item -Path TestDrive:\test.json).FullName
                    }
                }

                It 'Should return Ordered Dictionary with desired results' {
                    Export-IntuneCustomComplianceRule @jsonImport
                    $test = Get-Content -Path "TestDrive:\test.json" | ConvertFrom-Json
                    $test.Rules[0].SettingName                    | Should -Be -ExpectedValue 'Fake Firewall Policy'
                    $test.Rules[0].Operator                       | Should -Be -ExpectedValue 'IsEquals'
                    $test.Rules[0].DataType                       | Should -Be -ExpectedValue 'String'
                    $test.Rules[0].Operand                        | Should -Be -ExpectedValue 'Blocked'
                    $test.Rules[0].MoreInfoUrl                    | Should -Be -ExpectedValue 'https://bing.com'
                    $test.Rules[0].RemediationStrings.Language    | Should -Be -ExpectedValue 'en_US'
                    $test.Rules[0].RemediationStrings.Title       | Should -Be -ExpectedValue 'this is the title'
                    $test.Rules[0].RemediationStrings.Description | Should -Be -ExpectedValue 'this is my description'
                }
            }

            Context 'Should throw' {
                BeforeEach {
                    $invalidDest = @{
                        Setting = '{
                            "SettingName":  "Fake Firewall Policy",
                            "Operator":  "IsEquals",
                            "DataType":  "String",
                            "Operand":  "Blocked",
                            "MoreInfoURL":  "https://bing.com",
                            "RemediationStrings":  [
                                                       {
                                                           "Language":  "en_US",
                                                           "Title":  "this is the title",
                                                           "Description":  "this is my description"
                                                       }
                                                   ]
                        }'
                        Destination = (Get-Item -Path TestDrive:\nonjson.txt).FullName
                    }

                    $destInvalid = "Cannot validate argument on parameter 'Destination'. Export must be JSON format"

                    $invalidObject = @{
                        Setting = @{
                            SettingName = 'Fake Firewall Policy'
                            Operator    = 'IsEquals'
                            DataType    = 'String'
                            Operand     = 'Blocked'
                            MoreInfoUrl = 'https://bing.com'
                            RemediationStrings = @(
                                [ordered]@{
                                    Language    = 'en_US'
                                    Title       = 'this is a title'
                                    Description = 'This is my description'
                                }
                            )
                        }
                        Destination = (Get-Item -Path TestDrive:\test.json).FullName
                    }

                    $invalidFormat = 'Invalid input. Unsupported data type passed to Setting. Expected Array or OrderedDictionary'

                    $invalidString = @{
                        Setting = 'Invalid String'
                        Destination = (Get-Item -Path TestDrive:\test.json).FullName
                    }

                    $invalidStringError = 'Invalid input. String cannot be converted from JSON'
                }

                It 'Should throw when destination is not specified as Json' {
                    { Export-IntuneCustomComplianceRule @invalidDest } | Should -Throw -ExpectedMessage $destInvalid
                }

                It 'Should throw when Setting is not an Ordered Dictionary object' {
                    { Export-IntuneCustomComplianceRule @invalidObject } | Should -Throw -ExpectedMessage $invalidFormat
                }

                It 'Should throw when Setting sting is not valid format' {
                    { Export-IntuneCustomComplianceRule @invalidString } | Should -Throw -ExpectedMessage $invalidStringError
                }
            }
        }
    }
}
finally {
    Remove-Module -Name $moduleName
}
