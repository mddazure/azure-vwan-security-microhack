# Stop we firewall

$azfwwe = Get-AzFirewall -Name "microhack-we-hub-firewall" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwwe.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Stop useast firewall

$azfwuseast = Get-AzFirewall -Name "microhack-we-hub-firewall" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwuseast.Deallocate()
Set-AzFirewall -AzureFirewall $azfwuseast