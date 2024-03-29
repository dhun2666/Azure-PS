#command line input for NSG name, resource group

$nsgname = Read-Host -Prompt 'Input your NSG name'
$resourcegroup = Read-Host -Prompt 'Input your NSG resourcegroup name'
$csv = Read-Host -Prompt 'Input csv file name that has rules to add'


$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $resourcegroup

$readObj = import-csv ".\$($csv).csv"

foreach($rule in $readObj)
{ 
    $nsg | Add-AzNetworkSecurityRuleConfig -Name $rule.Name `
           -Access $rule.Access -Protocol $rule.Protocol -Direction $rule.direction -Priority $rule.priority `
           -SourceAddressPrefix $rule.SourceAddressPrefix.split(" ")  -SourcePortRange $rule.SourcePortRange.split(" ")`
           -DestinationAddressPrefix $rule.DestinationAddressPrefix.split(" ") -DestinationPortRange $rule.DestinationPortRange.split(" ") | Out-Null
}

$nsg | Set-AzNetworkSecurityGroup #| Out-Null