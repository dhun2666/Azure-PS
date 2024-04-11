#command line input for NSG name, resource group

$nsgname = Read-Host -Prompt 'Input name of NSG'
$resourcegroup = Read-Host -Prompt 'Input resourcegroup of NSG'
$csv = Read-Host -Prompt 'Input name of csv (without ".csv")'


$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $resourcegroup

$readObj = import-csv ".\$($csv).csv"

foreach($rule in $readObj)
{ 
    $nsg | Add-AzNetworkSecurityRuleConfig -Name $rule.Name `
           -Access $rule.Access -Protocol $rule.Protocol -Direction $rule.direction -Priority $rule.priority `
           -SourceAddressPrefix $rule.SourceAddressPrefix.split(" ")  -SourcePortRange $rule.SourcePortRange.split(" ")`
           -DestinationAddressPrefix $rule.DestinationAddressPrefix.split(" ") -DestinationPortRange $rule.DestinationPortRange.split(" ") | Out-Null
    If ($?)
    {
    echo "No error"
    }
    Else
    {
    echo "Error"
    }
}

$nsg | Set-AzNetworkSecurityGroup #| Out-Null
