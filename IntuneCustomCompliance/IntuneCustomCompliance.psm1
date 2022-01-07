function New-IntuneCustomComplianceSetting {
    <#
.SYNOPSIS
    Creates required JSON for Intune Custom Compliance file

.DESCRIPTION
    Building Intune custom compliance JSON can be cumbersome. Especially when you have multiple values for which you're checking against. This function aims to reduce the work required.

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
     New-IntuneCustomComplianceSetting -SettingName 'ComplianceSetting' -Operator 'IsEquals' -DataType 'String' -Operand 'ComplianceValue' -MoreInfoURL "https://dev.jackdavis.net" -Title $title

.EXAMPLE
     $MyQueryOutput | New-IntuneCustomComplianceSetting

.NOTES
    Author:  Jack D. Davis Jr.
    Website: http://dev.jackdavis.net
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$SettingName,
        [Parameter(Mandatory = $true)]
        [ValidateSet('IsEquals', 'NotEquals', 'GreaterThan', 'GreaterEquals', 'LessThan', 'LessEquals')]
        [string]$Operator,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Boolean', 'Int64', 'Double', 'String', 'DateTime', 'Version')]
        [string]$DataType,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$Operand,
        [Parameter(Mandatory = $true)]
        [string]$MoreInfoURL,
        [string]$Language = 'en_US',
        [string]$Title,
        [string]$Description,
        [string]$convert
    )
    process {
        if ($PSCmdlet.ShouldProcess($SettingName, $Operand)) {
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
                MoreInfoURL        = $MoreInfoURL ;
                RemediationStrings = $RemediationStrings
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
    Builds an extensive Intune Custom Compliance Rule

.DESCRIPTION
    Builds the Intune custom compliance Rule JSON file. See Docs for more information - https://docs.microsoft.com/en-us/mem/intune/protect/compliance-custom-json

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

.PARAMETER RemediationStrings
    Information that gets displayed in the Company Portal when a device is noncompliant to a setting. This information is intended to help users understand the remediation options to bring a device to a compliant state.

.EXAMPLE
     Export-IntuneCustomComplianceRule -Setting $allSettings -Destination $destination

.NOTES
    Author:  Jack D. Davis Jr.
    Website: http://www.Microsoft.com
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [array]$QueryResult,
        [Parameter(ValueFromPipeline)]
        [string]$sKeyName,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$sValueName,
        [Parameter(Mandatory = $true)]
        [ValidateSet('IsEquals', 'NotEquals', 'GreaterThan', 'GreaterEquals', 'LessThan', 'LessEquals')]
        [string]$Operator,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Boolean', 'Int64', 'Double', 'String', 'DateTime', 'Version')]
        [string]$DataType,
        [Parameter(Mandatory = $true)]
        [string]$MoreInfoURL,
        [Parameter(Mandatory = $false)]
        [string]$Language = 'en_US',
        [Parameter(Mandatory = $false)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Description
    )
    process {
        if ($PSCmdlet.ShouldProcess($QueryResult, $sKeyName, $sValueName)) {
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
    Exports JSON file for Intune Custom Compliance Rules

.DESCRIPTION
    Exports the Intune custom compliance Rule JSON file. See Docs for more information - https://docs.microsoft.com/en-us/mem/intune/protect/compliance-custom-json

.PARAMETER Setting
    The setting created for use with Intune custom compliance. This can be JSON or Hash table.

.PARAMETER Destination
    Filepath of exported JSON file

.PARAMETER isJSON
    Determines whether rule passed


.EXAMPLE
     Export-IntuneCustomComplianceRule -Setting $allSettings -Destination $destination

.NOTES
    Author:  Jack D. Davis Jr.
    Website: http://www.Microsoft.com
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        $Setting,
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Destination,
        [Parameter(Mandatory = $false)]
        $isJSON
    )
    process {
        if ($PSCmdlet.ShouldProcess($Setting)) {
            if ($isJSON) {
                $Setting = $Setting | ConvertFrom-Json
            }
            $rSettings = @{
                Rules = @($Setting)
            }
            return $rSettings | ConvertTo-Json -depth 100 -Compress | Out-File $Destination
        }
    }
}