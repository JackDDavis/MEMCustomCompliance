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

.PARAMETER Convert
    Converts output to JSON. Not recommended for use with Export Function

.EXAMPLE
     New-IntuneCustomComplianceSetting -SettingName 'ComplianceSetting' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $url -Title $title

.EXAMPLE
     $MyQueryOutput | New-IntuneCustomComplianceSetting -Convert

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
        [Parameter(Mandatory = $true, ValueFromPipeline)]
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
        [switch]$convert
    )
    process {
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

        if ($PSCmdlet.ShouldProcess($convert)) {
            return $r | ConvertTo-Json -depth 100
        }
        else {
            return $r
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

.PARAMETER sKeyName
    Setting Key column identified as property in query

.PARAMETER sValueName
    Setting Value column identified as property in query

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

.EXAMPLE
     New-IntuneCustomComplianceRuleSet -QueryResult $Output -sKeyName 'Name' -sValueName 'Action' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $uri -Title $title

.EXAMPLE
     $MyQueryOutput | New-IntuneCustomComplianceRuleSet -sKeyName 'Name' -sValueName 'Action' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL $uri -Title $title

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
        [string]$sKeyName,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$sValueName,
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
        [string]$Description
    )
    process {
        if ($PSCmdlet.ShouldProcess($sKeyName, $sValueName)) {
            $ruleSet = [System.Collections.ArrayList]@()
            foreach ($rule in $QueryResult) {
                $params = @{
                    SettingName = $rule.$sKeyName
                    Operator    = $Operator
                    DataType    = $DataType
                    Operand     = $rule.$sValueName
                    MoreInfoURL = $MoreInfoURL
                    Language    = $Language
                    Title       = $Title
                    Description = $Description
                }
                $iccs = New-IntuneCustomComplianceSetting @params
                $ruleSet.Add($iccs) | Out-Null
            }
            return $ruleSet
        }
    }
}
function Export-IntuneCustomComplianceRule {
    <#
.SYNOPSIS
    Exports an Intune Custom Compliance formatted JSON Rule

.DESCRIPTION
    Exports the Intune custom compliance Rule JSON file. See Docs for more information - https://docs.microsoft.com/en-us/mem/intune/protect/compliance-custom-json

.PARAMETER Setting
    The setting created for use with Intune custom compliance. This can be Array or OrderedDictionary.

.PARAMETER Destination
    Filepath of exported JSON file

.EXAMPLE
     Export-IntuneCustomComplianceRule -Setting $allSettings -Destination $destination

.NOTES
    Author:  Jack D. Davis Jr.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        $Setting,
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        [string]$Destination
    )
    process {
        if ($Setting.GetType().Name -eq 'String') {
            try {
                Write-Warning -Message 'Converting string object'
                $Setting = $Setting | ConvertFrom-Json -Depth 100
            }
            catch {
                throw 'Invalid input. String cannot be converted from JSON'
            }
        }
        elseif ($Setting.GetType().baseType.Name -ne 'Array') {
            if ($Setting.GetType().Name -ne 'OrderedDictionary') {
                throw 'Invalid input. Unsupported data type passed to Setting. Expected Array or OrderedDictionary'
            }
        }

        $rSettings = @{
            Rules = @($Setting)
        }

        if ($PSCmdlet.ShouldProcess($rSettings)) {
            return $rSettings | ConvertTo-Json -depth 100 -Compress | Out-File $Destination
        }
    }
}