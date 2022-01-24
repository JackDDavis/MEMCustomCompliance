$dir = ''
$modir = '<MODULE PATH>\MEMCustomCompliance' #Module location to load
Set-location $modir
$destination1 = "$dir\testingxa.json"
$destination2 = "$dir\testingxaConvert.json"
$destination3 = "$dir\testingxb.json"
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

# Run Cmdlet Tests
$fwRules = Get-NetFirewallRule | Where-Object { $PSItem.Direction -eq 'Inbound' } | Where-Object { $_.Name -like '*Edge*' } | Select-Object Name, Action
Write-Host "Creating Compliance Setting" -BackgroundColor RED
New-IntuneCustomComplianceSetting -SettingName $SettingName -Operator $Operator -Operand $Operand -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
$xa = New-IntuneCustomComplianceSetting -SettingName $SettingName -Operator $Operator -Operand $Operand -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
Write-Host "What-If: Create Compliance Setting using Convert switch" -BackgroundColor Yellow -ForegroundColor Black
New-IntuneCustomComplianceSetting -SettingName $SettingName -Operator $Operator -Operand $Operand -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description -convert -WhatIf
Write-Host "Creating Compliance Setting using Convert switch" -BackgroundColor RED
New-IntuneCustomComplianceSetting -SettingName $SettingName -Operator $Operator -Operand $Operand -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description -convert
$xaConverted = New-IntuneCustomComplianceSetting -SettingName $SettingName -Operator $Operator -Operand $Operand -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description -convert
Write-Host "WhatIf: Export Single Setting" -BackgroundColor Yellow -ForegroundColor Black
Export-IntuneCustomComplianceRule -Setting $xa -Destination $destination1 -WhatIf -Verbose
Write-Host "Exporting Single Setting" -BackgroundColor RED
Export-IntuneCustomComplianceRule -Setting $xa -Destination $destination1 -Verbose
Write-Host "Exporting Single Setting w/ Convert" -BackgroundColor RED
Export-IntuneCustomComplianceRule -Setting $xaConverted -Destination $destination2 -Verbose
Write-Host "WhatIf: Create RuleSet" -BackgroundColor Yellow -ForegroundColor Black
New-IntuneCustomComplianceRuleSet -QueryResult $fwRules -sKeyName $sKeyName -sValueName $sValueName -Operator $Operator -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description -WhatIf
Write-Host "Creating RuleSet" -BackgroundColor RED
New-IntuneCustomComplianceRuleSet -QueryResult $fwRules -sKeyName $sKeyName -sValueName $sValueName -Operator $Operator -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
$xb = New-IntuneCustomComplianceRuleSet -QueryResult $fwRules -sKeyName $sKeyName -sValueName $sValueName -Operator $Operator -DataType $dataType -MoreInfoURL $MoreInfoURL -Title $Title -Description $Description
Write-Host "Exporting RuleSet" -BackgroundColor RED
Export-IntuneCustomComplianceRule -Setting $xb -Destination $destination3 -Verbose
Write-Host "Exporting RuleSet as txt file - ERROR" -BackgroundColor RED
Export-IntuneCustomComplianceRule -Setting $xb -Destination $destination4 -Verbose
#Get-Content -Path $destination