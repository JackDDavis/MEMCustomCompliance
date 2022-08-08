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
    Author:  Jack D. Davis Jr.
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
        [string]$Operand,
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
        if ($PSCmdlet.ShouldProcess("Create Custom Compliance Setting", "$SettingName", "$r")) {
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
                if ($r.GetType().Name -eq 'String') {
                    try {
                        Write-Warning -Message 'Converting string object'
                        $r = $r | ConvertFrom-Json -Depth 100
                    }
                    catch {
                        throw 'Invalid input. String cannot be converted from JSON'
                    }
                }
                elseif ($r.GetType() -notlike 'Array') {
                    if ($r.GetType().Name -ne 'OrderedDictionary') {
                        throw 'Invalid input. Unsupported data type passed to Setting. Expected Array or OrderedDictionary'
                    }
                }
                $rSettings = @{
                    Rules = @($r)
                }
                if ($PSCmdlet.ShouldProcess("Exporting $rSettings as JSON to $Destination", $rSettings, $Destination)) {
                    $jsonOutput = $rSettings | ConvertTo-Json -depth 100 -Compress
                    if ($jsonOutput.contains('"Operand":"False"')) {
                        $jsonOutput = $jsonOutput.Replace('"Operand":"False"', '"Operand":false')
                    }
                    if ($jsonOutput.contains('"Operand":"True"')) {
                        $jsonOutput = $jsonOutput.Replace('"Operand":"True"', '"Operand":true')
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
    Setting Key column identified as property in query

.PARAMETER PropertyValue
    Setting Value column identified as property in query

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

.EXAMPLE
     New-IntuneCustomComplianceRuleSet -QueryResult $Output -PropertyName 'Name' -PropertyValue 'Action' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $uri -Title $title

.PARAMETER Destination
    Outputs array of Key/Value pairs to single JSON file

.NOTES
    Author:  Jack D. Davis Jr.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]$QueryResult,
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyName,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$PropertyValue,
        [Parameter(Mandatory = $true)]
        [ValidateSet('IsEquals', 'NotEquals', 'GreaterThan', 'GreaterEquals', 'LessThan', 'LessEquals')]
        [string]$Operator,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Boolean', 'Int64', 'Double', 'String', 'DateTime', 'Version')]
        [string]$DataType,
        [Parameter(Mandatory = $false)]
        [string]$MoreInfoURL,
        [Parameter(Mandatory = $false)]
        #[ValidateLength(5)]
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
        [string]$Destination

    )
    process {
        if ($PSCmdlet.ShouldProcess("Creating ArrayList from individual Custom Compliance Settings", $PropertyName, $PropertyValue)) {
            $ruleSet = [System.Collections.ArrayList]@()
            foreach ($rule in $QueryResult) {
                $params = @{
                    SettingName = $rule.$PropertyName
                    Operator    = $Operator
                    DataType    = $DataType
                    Operand     = $rule.$PropertyValue
                    MoreInfoURL = $MoreInfoURL
                    Language    = $Language
                    Title       = $Title
                    Description = $Description
                }
                $iccs = New-IntuneCustomComplianceSetting @params
                $ruleSet.Add($iccs) | Out-Null
            }
            if (!$Destination) {
                Write-Warning "To export, use '-Destination' parameter" -NoEnumerate
                return $ruleSet
            }
            if ($Destination) {
                if ($ruleSet.GetType().Name -eq 'String') {
                    try {
                        Write-Warning -Message 'Converting string object'
                        $ruleSet = $ruleSet | ConvertFrom-Json -Depth 100
                    }
                    catch {
                        throw 'Invalid input. String cannot be converted from JSON'
                    }
                }
                elseif ($ruleSet.GetType() -notlike 'Array') {
                    if ($ruleSet.GetType().Name -ne 'OrderedDictionary') {
                        throw 'Invalid input. Unsupported data type passed to Setting. Expected Array or OrderedDictionary'
                    }
                }

                $rSettings = @{
                    Rules = @($ruleSet)
                }

                if ($PSCmdlet.ShouldProcess("Exporting $rSettings as JSON to $Destination", $rSettings, $Destination)) {
                    return $rSettings | ConvertTo-Json -depth 100 -Compress | Out-File $Destination
                }
            }
        }
    }
}