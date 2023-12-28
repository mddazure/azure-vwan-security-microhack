# Stop we firewall

$azfwwe = Get-AzFirewall -Name "microhack-we-hub-firewall" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwwe.Deallocate()
Set-AzFirewall -AzureFirewall $azfwwe

# Stop useast firewall

$azfwuseast = Get-AzFirewall -Name "microhack-useast-hub-firewall" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwuseast.Deallocate()
Set-AzFirewall -AzureFirewall $azfwuseast 

# Stop swedencentral firewall

$azfwsec = Get-AzFirewall -Name "AzureFirewall_microhack-sec-secured-hub" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwsec.Deallocate()
Set-AzFirewall -AzureFirewall $azfwsec 


# Stop germany west central firewall

$azfwgewc = Get-AzFirewall -Name "AzureFirewall_microhack-gewc-secured-hub" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwgewc.Deallocate()
Set-AzFirewall -AzureFirewall $azfwgewc 