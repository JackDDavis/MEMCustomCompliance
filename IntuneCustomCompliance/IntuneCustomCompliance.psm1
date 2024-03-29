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
        [ValidateNotNullOrEmpty()]
        [string]$DataType,
        [Parameter(Mandatory = $true)]
        $Operand,
        [Parameter(Mandatory = $false)]
        [string]$MoreInfoURL,
        [Parameter(Mandatory = $false)]
        [ValidateSet('cs_CZ', 'da_DK', 'de_DE', 'el_GR', 'en_US', 'es_ES', 'fi_FI', 'fr_FR', 'hu_HU', 'it_IT', 'ja_JP', 'ko_KR', 'nb_NO', 'nl_NL', 'pl_PL', 'pt_BR', 'ro_RO', 'ru_RU', 'sv_SE', 'tr_TR', 'zh_CN', 'zh_TW')]
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
        [ValidateNotNullOrEmpty()]
        [string]$Operator,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [ValidateSet('Boolean', 'Int64', 'Double', 'String', 'DateTime', 'Version')]
        [string]$DataType,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [string]$MoreInfoURL,

        [Parameter(ParameterSetName = 'array')]
        [Parameter(ParameterSetName = 'hash')]
        [Parameter(Mandatory = $false)]
        [ValidateSet('cs_CZ', 'da_DK', 'de_DE', 'el_GR', 'en_US', 'es_ES', 'fi_FI', 'fr_FR', 'hu_HU', 'it_IT', 'ja_JP', 'ko_KR', 'nb_NO', 'nl_NL', 'pl_PL', 'pt_BR', 'ro_RO', 'ru_RU', 'sv_SE', 'tr_TR', 'zh_CN', 'zh_TW')]
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
            $snFormatPeriod = $false
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
                if ($k -match '[a-zA-Z]*\.') {
                    $k = $k.Replace('.', '_')
                    $snFormatPeriod = $true
                }
                $t = ($v).GetType().Name
                if ($DataType -eq 'String') {
                    $v = [string]$v
                }
                if (($null -eq $DataType) -or ($DataType -eq "")) {
                    $dt = switch ($t) {
                        'Int64'
                        { 'Int64' }
                        'Int32'
                        { 'Int64' }
                        'Int16'
                        { 'Int64' }
                        'Boolean'
                        { 'Boolean' }
                        'Double'
                        { 'Double' }
                        'String'
                        { 'String' }
                        'DateTime'
                        { 'DateTime' }
                        'Version'
                        { 'Version' }
                    }
                    if (-not($dt)) {
                        Write-Output "DataType [$t] on setting $k is not currently supported. Please specify a supported DataType. See Docs for more info - https://docs.microsoft.com/en-us/mem/intune/protect/compliance-custom-json"
                    }
                }
                else {
                    $dt = $DataType
                }
                if ($t -eq 'Version') {
                    $v = [string]$v
                }
                $params = @{
                    SettingName = $k
                    Operator    = $Operator
                    DataType    = $dt
                    Operand     = $v
                    MoreInfoURL = $MoreInfoURL
                    Language    = $Language
                    Title       = $Title
                    Description = $Description
                }
                try {
                    if (($params.SettingName) -and ($null -ne $params.Operand)) {
                        $iccs = New-IntuneCustomComplianceSetting @params
                        $ruleSet.Add($iccs) | Out-Null
                    }
                }
                catch {
                    { 'A detection rule was skipped and not added to ruleset because a null value was found in SettingName. Evaluate Key in Key/Value pair' }
                }
            }
            if ($snFormatPeriod) {
                Write-Output "One or more Rules were identified as having a period in the 'SettingName'. All periods have been replaced with an underscore in JSON output as it is not allowed. Please review and update your Discovery script accordingly." -Verbose
            }
            if (-not($Destination)) {
                Write-Output "To export, use '-Destination' parameter" -Verbose
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
