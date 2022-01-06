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
    A URL that’s shown to device users so they can learn more about the compliance requirement when their device is noncompliant for a setting. You can also use this to link to instructions to help users bring their device into compliance for this setting.

.PARAMETER RemediationStrings
    Information that gets displayed in the Company Portal when a device is noncompliant to a setting. This information is intended to help users understand the remediation options to bring a device to a compliant state.

.EXAMPLE
     New-IntuneCustomComplianceSetting -SettingName 'ComplianceSetting' -Operator 'IsEquals' -DataType 'String' -Operand 'Value to check' -MoreInfoURL "https://justanothertech.blog" -Title $title

.EXAMPLE
     $MyQueryOutput | New-IntuneCustomComplianceSetting

.NOTES
    Author:  Jack D. Davis Jr.
    Website: http://www.Microsoft.com
#>

    [CmdletBinding()]
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
    A URL that’s shown to device users so they can learn more about the compliance requirement when their device is noncompliant for a setting. You can also use this to link to instructions to help users bring their device into compliance for this setting.

.PARAMETER RemediationStrings
    Information that gets displayed in the Company Portal when a device is noncompliant to a setting. This information is intended to help users understand the remediation options to bring a device to a compliant state.

.EXAMPLE
     Export-IntuneCustomComplianceRule -Setting $allSettings -Destination $destination

.NOTES
    Author:  Jack D. Davis Jr.
    Website: http://www.Microsoft.com
#>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [array]$QueryResult,
        [Parameter(ValueFromPipeline)]
        [string]$SettingNameKey,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$OperandProperty,
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
        [Parameter(Mandatory = $false)]
        [string]$Language = 'en_US',
        [Parameter(Mandatory = $false)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Description
    )
    #$i = 1
    #$e = $QueryResult.Count
    $ruleSet = [System.Collections.ArrayList]@()
    foreach ($rule in $QueryResult) {
        $iccs = New-IntuneCustomComplianceSetting -SettingName $rule.$SettingNameKey -Operator $Operator -DataType $DataType -Operand $rule.$OperandProperty -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
        
        <#         if ($i -lt $e) {
            $iccs = $iccs + "," 
            $i = $i + 1
        } #>

        $ruleSet.Add($iccs) | Out-Null
    }
    return $ruleSet
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
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        $Setting,
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Destination,
        [Parameter(Mandatory = $false)]
        $isJSON
    )
    if ($isJSON) {
        $Setting = $Setting | ConvertFrom-Json
    }
    $rSettings = @{
        Rules = @($Setting)
    }
    return $rSettings | ConvertTo-Json -depth 100 -Compress | Out-File $Destination
}
Export-ModuleMember -Function *