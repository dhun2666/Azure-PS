#command line input for firewall policy, resource group, rullcollectiongroup

$policyname = Read-Host -Prompt 'Input your Firewall policy name'
$resourcegorup = Read-Host -Prompt 'Input your Firewall policy resourcegroup name'
$rulecollectiongroup = Read-Host -Prompt 'Input your Firewall policy rulecollectiongroup name, eg. DefaultNetworkRuleCollectionGroup'

$fp = Get-AzFirewallPolicy -Name $policyname -ResourceGroupName $resourcegorup
$rcg = Get-AzFirewallPolicyRuleCollectionGroup -Name $rulecollectiongroup -AzureFirewallPolicy $fp

$returnObj = @()
foreach ($rulecol in $rcg.Properties.RuleCollection) {

foreach ($rule in $rulecol.rules)
{
$properties = [ordered]@{
    RuleCollectionName = $rulecol.Name;
    RulePriority = $rulecol.Priority;
    ActionType = $rulecol.Action.Type;
    RUleConnectionType = $rulecol.RuleCollectionType;
    Name = $rule.Name;
    protocols = $rule.protocols -join ", ";
    SourceAddresses = $rule.SourceAddresses -join ", ";
    DestinationAddresses = $rule.DestinationAddresses -join ", ";
    SourceIPGroups = $rule.SourceIPGroups -join ", ";
    DestinationIPGroups = $rule.DestinationIPGroups -join ", ";
    DestinationPorts = $rule.DestinationPorts -join ", ";
    DestinationFQDNs = $rule.DestinationFQDNs -join ", ";
}
$obj = New-Object psobject -Property $properties
$returnObj += $obj
}

$returnObj | Export-Csv ".\$($fp.Name + "_"+ $rulecollectiongroup).csv" -NoTypeInformation
}

 