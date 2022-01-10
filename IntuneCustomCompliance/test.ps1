$dir = '< PATH >\MEMCustomCompliance'
Set-location $dir
$destination = "$dir\testing2.json"
Import-Module .\IntuneCustomCompliance

# Test Params
$SettingName = 'Fake Firewall Policy'
$Operator = 'IsEquals'
$dataType = 'String'
$Operand = 'Blocked'
$MoreInfoURL = "https://bing.com"
$Title = 'this is the title'
$Description = 'this is my description'
$sKeyName = 'Name'
$sValueName = 'Action'

# Run Pester tests
$pestPath = '<path>\MEMCustomCompliance\IntuneCustomCompliance\'
Set-Location -Path $pestPath
Import-Module Pester
Invoke-Pester -script "$pestPath\CustomCompliance.Tests.ps1" -Verbose
# -CodeCoverage .\CoverageTest.ps1 -Show All


# Run Cmdlet Tests
$fwRules = Get-NetFirewallRule | Where-Object { $PSItem.Direction -eq 'Inbound' } | Where-Object { $_.Name -like '*Edge*' } | Select-Object Name, Action
Write-Host "Creating Compliance Setting" -BackgroundColor RED
New-IntuneCustomComplianceSetting -SettingName $SettingName -Operator $Operator -Operand $Operand -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
Write-Host "Creating RuleSet" -BackgroundColor RED
New-IntuneCustomComplianceRuleSet -QueryResult $fwRules -sKeyName $sKeyName -sValueName $sValueName -Operator $Operator -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
$Rule01 = New-IntuneCustomComplianceRuleSet -QueryResult $fwRules -sKeyName $sKeyName -sValueName $sValueName -Operator $Operator -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
Write-Host "Exporting JSON" -BackgroundColor RED
Export-IntuneCustomComplianceRule -Setting $Rule01 -Destination $destination -Verbose
#Get-Content -Path $destination