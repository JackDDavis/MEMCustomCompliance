function New-IntuneCustomComplianceSetting {
    <#
.SYNOPSIS
    Creates an Intune Custom Compliance Setting

.DESCRIPTION
    This cmdlet creates the Intune Custom Compliance Setting. Setting can be converted to JSON with '-convert'. This should not be converted if using module Export cmdlet

.PARAMETER SettingName
    The name of the custom setting to use for base compliance

.PARAMETER Operator
    Represents a specific action that is used to build a compliance rule. For options, see the following list of supported operators.

.PARAMETER DataType
    The type of data that you can use to build your compliance rule. For options, see the following list of supported DataTypes.

.PARAMETER Operand
    Represent the values that the operator works on.

.PARAMETER MoreInfoURL
    A URL that is shown to device users so they can learn more about the compliance requirement when their device is noncompliant for a setting. You can also use this to link to instructions to help users bring their device into compliance for this setting.

.PARAMETER Language
    Remediation detail language for information displayed in the Company Portal when a device is noncompliant to a setting.

.PARAMETER Title
    Remediation detail title for information displayed in the Company Portal when a device is noncompliant to a setting.

.PARAMETER Description
    Remediation description detail that gets displayed in the Company Portal when a device is noncompliant to a setting. This information is intended to help users understand the remediation options to bring a device to a compliant state.

.PARAMETER Destination
    Outputs array of new rule to JSON file

.PARAMETER Convert
    Converts output to JSON. Not recommended for use with Export Function

.EXAMPLE
     New-IntuneCustomComplianceSetting -SettingName 'ComplianceSetting' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $url -Title $title

.NOTES
    Author:  Jack D. Davis
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$SettingName,
        [Parameter(Mandatory = $true)]
        [ValidateSet('IsEquals', 'NotEquals', 'GreaterThan', 'GreaterEquals', 'LessThan', 'LessEquals')]
        [string]$Operator,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Boolean', 'Int64', 'Double', 'String', 'DateTime', 'Version')]
        [string]$DataType,
        [Parameter(Mandatory = $true)]
        $Operand,
        [Parameter(Mandatory = $false)]
        [string]$MoreInfoURL,
        [Parameter(Mandatory = $false)]
        [string]$Language = 'en_US',
        [Parameter(Mandatory = $false)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [System.IO.FileInfo]
        [ValidateScript({
                if ($PSItem.Name.EndsWith(".json")) {
                    $true
                }
                else {
                    throw "Export must be JSON format"
                }
            })]
        [string]$Destination,
        [Parameter(Mandatory = $false)]
        [switch]$convert
    )
    process {
        if ($PSCmdlet.ShouldProcess("Create Custom Compliance Setting", "SettingName", "$SettingName")) {
            $RemediationStrings = @(
                [ordered]@{
                    Language    = $Language;
                    Title       = $Title;
                    Description = $Description
                }
            )
            $r = [ordered]@{
                SettingName        = $SettingName;
                Operator           = $Operator;
                DataType           = $DataType;
                Operand            = $Operand ;
                MoreInfoURL        = $MoreInfoURL;
                RemediationStrings = $RemediationStrings
            }
            if ($Destination) {
                $rSettings = @{
                    Rules = @($r)
                }
                $exportName = $rSettings.Rules.SettingName
                if ($PSCmdlet.ShouldProcess("Exporting $exportName as JSON to $Destination", $rSettings, $Destination)) {
                    $jsonOutput = $rSettings | ConvertTo-Json -depth 100
                    if ($jsonOutput.contains('"Operand":  "False"')) {
                        $jsonOutput = $jsonOutput.Replace('"Operand":  "False"', '"Operand": false')
                    }
                    if ($jsonOutput.contains('"Operand":  "True"')) {
                        $jsonOutput = $jsonOutput.Replace('"Operand":  "True"', '"Operand": true')
                    }
                    $jsonOutput | Out-File $Destination
                }
            }
            if ($convert) {
                return $r | ConvertTo-Json -depth 100
            }
            else {
                return $r
            }
        }
    }
}

function New-IntuneCustomComplianceRuleSet {
    <#
.SYNOPSIS
    Creates required JSON for Intune Custom Compliance file

.DESCRIPTION
    Builds Intune custom compliance rule which may include several settings.

.PARAMETER QueryResult
    Variable of stored query result

.PARAMETER PropertyName
    Setting Key column identified as property in query. Applicable to QueryResult parameter set only

.PARAMETER PropertyValue
    Setting Value column identified as property in query. Applicable to QueryResult parameter set only

.PARAMETER Operator
    Represents a specific action that is used to build a compliance rule. For options, see the following list of supported operators.

.PARAMETER DataType
    The type of data that you can use to build your compliance rule. For options, see the following list of supported DataTypes.

.PARAMETER MoreInfoURL
    A URL that is shown to device users so they can learn more about the compliance requirement when their device is noncompliant for a setting. You can also use this to link to instructions to help users bring their device into compliance for this setting.

.PARAMETER Language
    Remediation detail language for information displayed in the Company Portal when a device is noncompliant to a setting.

.PARAMETER Title
    Remediation detail title for information displayed in the Company Portal when a device is noncompliant to a setting.

.PARAMETER Description
    Remediation description detail that gets displayed in the Company Portal when a device is noncompliant to a setting. This information is intended to help users understand the remediation options to bring a device to a compliant state.

.INPUTS

Array or Hashtable. Piping results to -QueryResult paramter set

.OUTPUTS

System.Collections.Hashtable. Converted into JSON format for easy export

.EXAMPLE
     New-IntuneCustomComplianceRuleSet -QueryResult $Output -PropertyName 'Name' -PropertyValue 'Action' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $uri -Title $title

.EXAMPLE
     New-IntuneCustomComplianceRuleSet -CustomQueryResult $Output -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $uri -Title $title

.PARAMETER Destination
    Outputs array of Key/Value pairs to single JSON file

.NOTES
    Author:  Jack D. Davis
#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'array')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'array')]
        [ValidateNotNullOrEmpty()]
        $QueryResult,

        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'hash')]
        [ValidateNotNullOrEmpty()]
        [hashtable]$CustomQueryResult,

        [Parameter(Mandatory = $true, ParameterSetName = 'array')]
        [string]$PropertyName,

        [Parameter(Mandatory = $true, ParameterSetName = 'array')]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyValue,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $true)]
        [ValidateSet('IsEquals', 'NotEquals', 'GreaterThan', 'GreaterEquals', 'LessThan', 'LessEquals')]
        [string]$Operator,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $true)]
        [ValidateSet('Boolean', 'Int64', 'Double', 'String', 'DateTime', 'Version')]
        [string]$DataType,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [string]$MoreInfoURL,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [string]$Language = 'en_US',

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [System.IO.FileInfo]
        [ValidateScript({
                if ($PSItem.Name.EndsWith(".json")) {
                    $true
                }
                else {
                    throw "Export must be JSON format"
                }
            })]
        [string]$Destination
    )
    begin {
        if ($CustomQueryResult) {
            $arr = @()
            $CustomQueryResult.GetEnumerator() | ForEach-Object {
                $arr += [pscustomobject]@{
                    PropertyName = $PSItem.Name ; PropertyValue = $PSItem.Value
                };
            }
            $QueryResult = $arr
        }
    }
    process {
        if ($PSCmdlet.ShouldProcess("Creating ArrayList from individual Custom Compliance Settings", $PropertyName, $PropertyValue)) {
            $ruleSet = [System.Collections.ArrayList]@()
            foreach ($rule in $QueryResult) {
                if ($CustomQueryResult) {
                    $k = $rule.PropertyName
                    $v = $rule.PropertyValue
                }
                else {
                    $k = $rule.$PropertyName
                    $v = $rule.$PropertyValue
                }
                $params = @{
                    SettingName = $k
                    Operator    = $Operator
                    DataType    = $DataType
                    Operand     = $v
                    MoreInfoURL = $MoreInfoURL
                    Language    = $Language
                    Title       = $Title
                    Description = $Description
                }
                try {
                    if (($null -ne $params.SettingName) -and ($null -ne $params.Operand)) {
                        $iccs = New-IntuneCustomComplianceSetting @params
                        $ruleSet.Add($iccs) | Out-Null
                    }
                    else {
                        Write-Warning 'A setting rule was skipped because a null value was found in Setting Name' -Verbose
                    }
                }
                catch {
                    { throw }
                }

            }
            if (-not($Destination)) {
                Write-Warning "To export, use '-Destination' parameter"
                return $ruleSet
            }
            if ($Destination) {
                $rSettings = @{
                    Rules = @($ruleSet)
                }
                if ($PSCmdlet.ShouldProcess("Exporting detection ruleset as JSON to $Destination", $rSettings, $Destination)) {
                    return $rSettings | ConvertTo-Json -depth 100 | Out-File $Destination
                }
            }
        }
    }
}
