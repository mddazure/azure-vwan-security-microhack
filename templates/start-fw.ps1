# Start we firewall

$virtualhubwe = get-azvirtualhub -ResourceGroupName "vwan-security-microhack-hub-rg" -name "microhack-we-secured-hub"
$azfwwe = Get-AzFirewall -Name "microhack-we-hub-firewall" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwwe.Allocate($virtualhubwe.Id)
$azfwwe | Set-AzFirewall

# Start useast firewall

$virtualhubuseast = get-azvirtualhub -ResourceGroupName "vwan-security-microhack-hub-rg" -name "microhack-useast-secured-hub"
$azfwuseast = Get-AzFirewall -Name "microhack-useast-hub-firewall" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwuseast.Allocate($virtualhubuseast.Id)
$azfwuseast | Set-AzFirewall

# Start sec firewall

$virtualhubsec = get-azvirtualhub -ResourceGroupName "vwan-security-microhack-hub-rg" -name "microhack-sec-secured-hub"
$azfwsec = Get-AzFirewall -Name "AzureFirewall_microhack-sec-secured-hub" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwsec.Allocate($virtualhubsec.Id)
$azfwsec | Set-AzFirewall

# Start gewc firewall

$virtualhubgewc = get-azvirtualhub -ResourceGroupName "vwan-security-microhack-hub-rg" -name "microhack-gewc-secured-hub"
$azfwgewc = Get-AzFirewall -Name "AzureFirewall_microhack-gewc-secured-hub" -ResourceGroupName "vwan-security-microhack-hub-rg"
$azfwgewc.Allocate($virtualhubgewc.Id)
$azfwgewc | Set-AzFirewall