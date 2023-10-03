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