# Function to retrieve Application Gateways
function Retrieve-ApplicationGateways {

    $applicationGateways = Get-AzApplicationGateway

    if ($null -eq $applicationGateways -or $applicationGateways.Count -eq 0) {
        return $null
    }

    return $applicationGateways
}

# Function to list Application Gateways
function List-ApplicationGateways {
    param (
        [Parameter(Mandatory=$true)]
        [array]$applicationGateways
    )
    Write-Output "Application Gateways in your subscription:"
    for ($i = 0; $i -lt $applicationGateways.Count; $i++) {
        Write-Output ("[{0}] {1} (Resource Group: {2})" -f $i, $applicationGateways[$i].Name, $applicationGateways[$i].ResourceGroupName)
    }
}

# Function to select an Application Gateway
function Select-ApplicationGateway {
    param (
        [Parameter(Mandatory=$true)]
        [array]$applicationGateways
    )

    $selectedIndex = Read-Host "Enter the number corresponding to the Application Gateway"
    if ($selectedIndex -lt 0 -or $selectedIndex -ge $applicationGateways.Count -or -not [int]::TryParse($selectedIndex, [ref]$null)) {
        Write-Output "Invalid selection."
        return $null
    }

    return $applicationGateways[$selectedIndex]
}


# Retrieve Application Gateways
Write-Output "Retrieving Application Gateways..."
$applicationGateways = Retrieve-ApplicationGateways

if ($null -eq $applicationGateways -or $applicationGateways.Count -eq 0) {
    Write-Output "No Application Gateways found in your subscription."
    Break
}

# List Application Gateways if any were retrieved and select one

if ($applicationGateways) {
    List-ApplicationGateways -applicationGateways $applicationGateways
    $selectedAppGateway = Select-ApplicationGateway -applicationGateways $applicationGateways

    if ($selectedAppGateway) {
        Write-Output ("Stopping Application Gateway '{0}' in Resource Group '{1}'..." -f $selectedAppGateway.Name, $selectedAppGateway.ResourceGroupName)
        $AppGw = Get-AzApplicationGateway -Name $selectedAppGateway.Name -ResourceGroupName $selectedAppGateway.ResourceGroupName 
        Stop-AzApplicationGateway -ApplicationGateway $AppGw
        Write-Output "Application Gateway '$($selectedAppGateway.Name)' in Resource Group '$($selectedAppGateway.ResourceGroupName)' has been stopped."
    } else {
        Write-Output "No Application Gateway was selected for stopping."
    }
} else {
    Write-Output "No Application Gateways were retrieved."
}
