# MEMCustomCompliance

With the availability of Custom Compliance, customers now have the ability to further define what device compliance means for their organization's managed Windows devices. Depending on your Custom Compliance use case, this can become quite the task. Manually building the correctly formatted JSON can be an error prone process.
To assist with this, we are providing a PowerShell module for Custom Compliance. Today, the module consists of 2 cmdlets:
1)	New-IntuneCustomComplianceSetting cmdlet can be used to properly format an individual setting. This cmdlet will provide the JSON export required for upload.
2)	New-IntuneCustomComplianceRuleSet cmdlet can accept more complex multi-property queries and output and transform each setting and its value into a JSON ruleset that can be imported into Intune.

ReleaseNotes: <br />
*1.1.1 - Language ValidationSet & error handling for periods in SettingName (Latest) <br />
*1.1.0 - CustomQueryResult Parameter set for hashtable handling <br />
*1.0.1 - Code cleanup and Unit test improvements <br />
*1.0 - Initial stable Release <br />
