#command line input for firewall policy, resource group, rullcollectiongroup

$policyname = Read-Host -Prompt 'Input your Firewall policy name'
$resourcegorup = Read-Host -Prompt 'Input your Firewall policy resourcegroup name'
$rulecollectiongroup = Read-Host -Prompt 'Input Firewall policy rulecollectiongroup name to add rule'
$priority = Read-Host -Prompt 'Input priority to be set for a new rule'
$csv = Read-Host -Prompt 'Input csv file name that has rules'


$targetfp = Get-AzFirewallPolicy -Name $policyname -ResourceGroupName $resourcegorup
$targetrcg = New-AzFirewallPolicyRuleCollectionGroup -Name $rulecollectiongroup -Priority $priority -FirewallPolicyObject $targetfp

$RulesfromCSV = @()
# Change the folder where the CSV is located
$readObj = import-csv ".\$($csv).csv"
foreach ($entry in $readObj)
{
    $properties = [ordered]@{
        RuleCollectionName = $entry.RuleCollectionName;
        RulePriority = $entry.RulePriority;
        ActionType = $entry.ActionType;
        Name = $entry.Name;
        protocols = $entry.protocols -split ", ";
        SourceAddresses = $entry.SourceAddresses -split ", ";
        DestinationAddresses = $entry.DestinationAddresses -split ", ";
        SourceIPGroups = $entry.SourceIPGroups -split ", ";
        DestinationIPGroups = $entry.DestinationIPGroups -split ", ";
        DestinationPorts = $entry.DestinationPorts -split ", ";
        DestinationFQDNs = $entry.DestinationFQDNs -split ", ";
    }
    $obj = New-Object psobject -Property $properties
    $RulesfromCSV += $obj
}

$RulesfromCSV
$rules = @()
foreach ($entry in $RulesfromCSV)
{
    $RuleParameter = @{
        Name = $entry.Name;
        Protocol = $entry.protocols
        sourceAddress = $entry.SourceAddresses
        DestinationAddress = $entry.DestinationAddresses
        DestinationPort = $entry.DestinationPorts
    }
    $rule = New-AzFirewallPolicyNetworkRule @RuleParameter
    $NetworkRuleCollection = @{
        Name = $entry.RuleCollectionName
        Priority = $entry.RulePriority
        ActionType = $entry.ActionType
        Rule       = $rules += $rule
    }
}

# Create a network rule collection
$NetworkRuleCategoryCollection = New-AzFirewallPolicyFilterRuleCollection @NetworkRuleCollection
# Deploy to created rule collection group
Set-AzFirewallPolicyRuleCollectionGroup -Name $targetrcg.Name -Priority $priority -RuleCollection $NetworkRuleCategoryCollection -FirewallPolicyObject $targetfp
