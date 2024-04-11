#command line input for NSG name, resource group

$nsgname = Read-Host -Prompt 'Input name of NSG'
$resourcegroup = Read-Host -Prompt 'Input resourcegroup of NSG'

$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $resourcegroup | Get-AzNetworkSecurityRuleConfig | Select-Object Name, @{n='Priority'; e={$_.Priority -join ' '}}, @{n='Protocol'; e={$_.Protocol -join ' '}}, @{n ='SourcePortRange'; e={$_.SourcePortRange -join ' '}}, @{n ='DestinationPortRange'; e={$_.DestinationPortRange -join ' '}}, @{n ='SourceAddressPrefix'; e={$_.SourceAddressPrefix -join ' '}}, @{n ='DestinationAddressPrefix'; e={$_.DestinationAddressPrefix -join ' '}}, Access, Direction | Export-Csv ".\$($nsgname).csv" -NoTypeInformation
