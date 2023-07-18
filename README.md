# **Security in Azure Virtual WAN MicroHack**

# Contents

[Introduction](#introduction)

[Objectives](#objectives)

[Lab](#lab)

[Prequisites](#prerequisites)

[Scenario 1: Secure Private Traffic](#scenario-1-secure-private-traffic)

[Scenario 2: Secure Internet Traffic](#scenario-2-secure-internet-traffic)

[Scenario 3: SDWAN thriugh NVA in Spoke](#scenario-3-sdwan-through-nva-in-spoke)

[Scenario 4: Inther through Firewall in Spoke](#scenario-4-internet-through-firewall-in-spoke)

[Close Out](#close-out)

# Introduction
This MicroHack demontrates the newly released [Routing Intent and Routing Policies](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies) capabilities in Azure Virtual WAN. It is a sequel to [Routing in Azure Virtual WAN MicroHack](https://github.com/mddazure/azure-vwan-microhack), and it is recommended to complete Scenario's 1 - 3 of that MicroHack before starting this one.

The lab starts with a dual Secured Hub Virtual WAN, with Spoke VNETs connected but no Security Policies configured.

You will enable Routing Intent and Routing Policies to secure Private and Internet traffic through the firewalls in each Hub.

Next, you add branch two connections (simulated by VNETs with a VPN Gateway) to one hub, and filter branch-to-branch traffic through the hub firewall.

Then a simulated SD-WAN branch location is connected to a Network Virtual Appliance in a spoke; the SD-WAN IP space is dynamically injected into the VWAN through BGP.

Finally, outbound internet traffic is routed through an NVA firewall in a spoke, rather than through the hub firewalls.

# Objectives
After completing this MicroHack you will:
- Understand traffic flow control through Secured Hubs with Azure Firewall. 
- Know how to enable Routing Intent and Private and Internet Routing Policies.
- Know how to leverage the Hub BGP capability to enable an NVA in a spoke.

# Lab

The lab consists of a Virtual WAN with Secured Hubs in West Europe and US East, 4 Spoke VNETs (2 in West Europe, 1 in US East and 1 US West), an NVA VNET in West-Europe and simulated Branch locations in UK South, Sweden-Central and North Europe.

Each of the Spoke and Branch VNETs contains a Virtual Machine running a basic web site.

The NVA VNET contains a Cisco CSR1000v router, which will be used to simulate an SD-WAN concentrator in a Spoke. During the course of the lab, an OPNSense Firewall will be deployed into the NVA VNET to secure outbound internet traffic.

The Services VNET contains a Bastion instance `bastion-service` which is used to connect to VMs across the lab using the IP Connect function.

The lab looks like this (with green components pre-deployed through Terraform, see [Prequisites](#prerequisites) below, and blue parts deployed during the scenarios):

![image](images/microhack-vwan-security.png)

:exclamation: The resources deployed in this lab incur a combined charge of around $170 per day, so do remember to delete the environment when done!

# Prerequisites
To make the most of your time on this MircoHack, the lab in the diagram above is deployed and configured for you through Terraform. You will focus on enabling and inspecting network security through the Azure portal and Cloud Shell.
## Task 1: Deploy
Steps:
- Log in to Azure Cloud Shell at https://shell.azure.com/ and select Bash
- Set environment variables required by Terraform. These should already be present, but may have been removed after an upgrade to Cloud Shell; Terraform will fail if they are not present:
  
  `export ARM_USE_MSI=true`
  
  `export ARM_SUBSCRIPTION_ID=<your sub id>`

  `export ARM_TENANT_ID=<aad tenant id>`

- Ensure Azure CLI and extensions are up to date:
  
  `az upgrade --yes`
  
- If necessary select your target subscription:
  
  `az account set --subscription <Name or ID of subscription>`
  
- Clone the  GitHub repository:
  
  `git clone https://github.com/mddazure/azure-vwan-security-microhack`
  
  - Change directory:
  
  `cd ./azure-vwan-security-microhack/templates`

- Accept the terms for the CSR1000v Marketplace offer:
  
  `az vm image terms accept --urn cisco:cisco-csr-1000v:16_12_5-byol:latest`

- Initialize terraform and download the azurerm resource provider:

  `terraform init`

- Now start the deployment (when prompted, confirm with **yes** to start the deployment):
 
  `terraform apply`

Deployment takes approximately 30 minutes. 

## Task 2: Explore and verify

After the Terraform deployment concludes successfully, the following has been deployed into your subscription:
- A resource group named **vwan-security-microhack-spoke-rg** containing:
  - Four Spoke VNETs, each containing a Virtual Machine running a simple web site.
  - Three Onprem VNETs each containing a Virtual Machine running a simple web site and a VNET Gateway.
  - A Services VNET containing a Bastion Host.
  - An NVA VNET containing a Cisco CSR1000v router.
- A resource group named **vwan-security-microhack-hub-rg** containing:
  - A Virtual WAN resource with two Hubs, each containing an Azure Firewall and a VPN Gateway.
  - A parent firewall policy and child policies for each region.
  - IP Groups for spoke- and branch prefixes, referenced by the firewall policies.

Verify these resources are present in the portal.

Credentials are identical for all VMs, as follows:
- User name: AzureAdmin
- Password: Microhack2023

You may log on to each VM through the Bastion instance in the Services VNET. Navigate to Bastion instance `bastion-service`, click Connect and enter the IP address of the VM you want to connect to:
- spoke-1-vm: 172.16.1.4
- spoke-2-vm: 172.16.2.4
- spoke-3-vm: 172.16.3.4
- spoke-4-vm: 172.16.4.4
- onprem-vm: 10.0.1.4 
- onprem2-vm: 10.0.3.4
- onprem3-vm: 10.0.5.4

Open a command prompt and type `curl localhost`. The response will be the VM name. 

:exclamation: Branch locations onprem, onprem-2 and on-prem-3 are not connected yet, so their VMs will not be reachable from the Bastion instance in the Services VNET.

:exclamation: Connect to nva-csr-vm (the CSR1000v Cisco router) through Serial console from the VM blade in stead of through Bastion. This access method is independent from network connectivity to the VM and avoids the risk of being locked out during configuration changes.

# Scenario 1: Secure Private Traffic
In this scenario, you will secure Spoke-to-Spoke and Branch-to-Spoke traffic accross Secured Hubs in different regions. 
:exclamation: Remember - prior to Routing Intent, securing Spoke-to-Spoke and Branch-to-Spoke traffic through Azure Firewall was restricted to a single Hub; securing traffic across Hubs was not possible.

## Task 1: Baseline
Both Hubs have Azure Firewall deployed, but securing traffic through the firewalls is not yet configured.

Connect to spoke-1-vm, open a command prompt and attempt to connect to the web server on spoke-2-vm at 172.16.2.4, spoke-3-vm at 172.16.3.4 and spoke-4-vm at 172.16.4.4:

`curl 172.16.2.4`

`curl 172.16.3.4`

`curl 172.16.4.4`

❓ Does it connect?

Check the routing table on spoke-1-vm in Cloud Shell:

`az network nic show-effective-route-table -g vwan-security-microhack-spoke-rg -n spoke-1-nic --output table`

Look up the address of the firewall installed in the West Europe hub `microhack-we-hub-firewall`

Observe the next hop for spoke-2-vnet (172.16.2.0/24), spoke-3-vnet (172.16.3.0/24), spoke-4-vnet (172.16.4.0/24).

❓ Do the routes for the Spokes point to the firewall?

## Task 2: Secure Spoke-to-Spoke traffic
Navigate to the West Europe Hub and click Routing Intent and Routing Policies.

In the dropdown under Private Traffic, select Azure Firewall and under Next Hop Resource click `microhack-we-hub-firewall`, then click Save.

![image](images/enable-ri-we.png)

Next, navigate to the US East Hub and again click Routing Policies. 

In the dropdown under Private Traffic, select Azure Firewall and under Next Hop Resource click `microhack-useast-hub-firewall`, then click Save.

From spoke-1-vm, again attempt to spoke-2-vm at 172.16.2.4, spoke-3-vm at 172.16.3.4 and spoke-4-vm at 172.16.4.4:

`curl 172.16.2.4`

`curl 172.16.3.4`

`curl 172.16.4.4`

❓ Does it connect?

Navigate to Firewall Policies and inspect each of the policies:

![image](images/firewall-policies.png)

Modify `microhack-fw-parent-policy` so that traffic between spoke-1-vm and spoke-3-vm is no longer blocked by either firewall.

Now navigate back to the West Europe Hub and click Effective Routes. Under Choose resource type select Azure Firewall and under Resource `microhack-we-hub-firewall`:

![image](images/we-fw-eff-rts.png)

Inspect the route table, observe routes for directly connected and cross-hub spoke routes.

## Task 3: Secure Branch-to-Branch traffic
Connect simulated Branch locations `onprem` and `onprem-2` to the West Europe Hub, by running these shell scripts from the `./azure-vwan-security-microhack/templates` directory in Cloud Shell:

`./connect-branch.sh`

`./connect-branch2.sh`

The scripts create VPN sites on the West Europe hub, and connect to the VNET Gateways in onprem-vnet and onprem2-vnet.

Connect to onprem-vm via Bastion, open a command prompt and attempt to connect to the web server on onprem2-vm at 10.0.3.4:

`curl 10.0.3.4`

:question: Does it connect?

:question: Can you deduce where the connection from onprem-vm to onprem2-vm is blocked?
Hint: Inspect the `microhack-fw-we-child-policy` firewall policy.

Simulated Branch locations onprem-vnet and onprem2-vnet are both connected to the VPN Gateway on the West Europe hub.

:point_right: Before the Routing Intent update, traffic between Branch S2S VPN connections on the same gateway would loop directly through the gateway and would not be inspected by the firewall in the Hub (red flow in the diagram below). 
Post-RI, traffic from S2S and P2S VPN connections is now forwarded from the gateway to the firewall, allowing Branch-to-Branch connectivity to be controlled centrally by the Hub firewall (orange flow on the diagram).

![image](images/b2b-via-fw.png)

Navigate to Firewall Policies and update network rules in `microhack-fw-we-child-policy` to permit connectity from onprem-vnet to onprem2-vnet and v.v. 

# Scenario 2: Secure Internet Traffic
You will now secure traffic outbound to internet through the firewall in each Hub. Next you will enable inbound connections from an external client to the web server on the VM in Spoke 4.

## Task 1: Baseline
Connect to spoke-1-vm via Bastion, open a command prompt and obtain the outbound IP address from ipconfig.io:

`curl ipconfig.io`

❓ Which IP address does it connect from? What resource does this address belong to?

Check the routing on spoke-1-vm in Could Shell:

`az network nic show-effective-route-table -g vwan-security-microhack-spoke-rg -n spoke-1-nic --output table`

❓ Where does the default route point?

## Task 2: Secure outbound

### Configure

Navigate to the West Europe Hub and click Routing Intent and Routing Policies.

In the dropdown under Internet Traffic, select Azure Firewall and under Next Hop Resource click `microhack-we-hub-firewall`, then click Save.

![image](images/enable-internet-security.png)

Next, navigate to the US East Hub and again click Routing Policies. 

In the dropdown under Internet Traffic, select Azure Firewall and under Next Hop Resource click `microhack-useast-hub-firewall`, then click Save.

### Verify

From spoke-vm-1, again do `curl ipconfig.io`.

❓ Which IP address does it connect from? What resource does this address belong to?

Check the routing on spoke-1-vm in Could Shell:

`az network nic show-effective-route-table -g vwan-security-microhack-spoke-rg -n spoke-1-nic --output table`

❓ Where does the default route now point?

Now connect to spoke-4-vm via Bastion, open a command prompt and obtain the outbound IP address from ipconfig.io:

`curl ipconfig.io`

❓ Which IP address does it connect from? What resource does this address belong to?

Check the routing on spoke-4-vm in Could Shell:

`az network nic show-effective-route-table -g vwan-security-microhack-spoke-rg -n spoke-4-nic --output table`

❓ Where does the default route point?

## Task 3: Secure inbound

You will now enable inbound connectivity from the internet to the web server on spoke-4-vm, through a Destination Network Address Translation (DNAT)
rule on the firewall in the US East hub.

Spoke-4-vm does not have a public IP address and is not directly reachable from the internet. Clients on the internet will send traffic destined for this VM to the hub firewall's public IP address. A DNAT rule on the firewall will translate the destination IP address from the firewall's public IP address into the VM's private IP address. On the return traffic from the VM, the firewall will translate the source address from the VM's private IP into the firewall's public IP, and send it out to the internet.

:point_right: DNAT rules on Azure Firewall also translate the inbound traffic's source address from the client's public IP into the firewall's private IP (Source NAT). This means that the receiving web server will not see the sender's orginal public IP. This is not standard behaviour on all firewall platforms, it is a property of Azure firewall. If masking client IP is undesirable, a recommended architecture for inbound traffic is to route inbound web traffic through Application Gateway in the spoke VNET. Application Gateway also SNAT's the sending client's IP address, but retains it in an x-forwarded-for header. See [Plan for inbound and outbound internet connectivity](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity) for more information.

Navigate to the firewall in the US East hub, `microhack-useast-hub-firewall` and copy the Firewall public IP.

Navigate to the `microhack-fw-useast-child-policy` firewall policy, and click DNAT rules. Click +Add a rule collection and complete as follows:
- Name: useast-dnat-rule-coll
- Rule collection type: DNAT
- Priority: 150
- Rule collection group: child-useast-rule-coll-grp (select from dropdown)

Under Rules:
- Name: spoke-4-in
- Source type: IP Address
- Source: *
- Protocol: TCP
- Destination Ports: 80
- Destination Type: IP Address
- Destination: [Firewall public IP]
- Translated type: IP Address
- Translated address or FQDN: 172.16.4.4
- Translated port: 80

Click Add.

![image](images/dnat-us-east-fw.png)

Wait for the change to complete.

On your laptop, open a command prompt and enter:

`curl [Firewall public IP]`

The response should read "spoke-4-vm".

![image](images/spoke-4-vm-inbound.png)

To observe the DNAT'd and SNAT'd request on the target VM:
- log on to spoke-4-vm, open file explorer and browse to %SystemDrive%\inetpub\logs\LogFiles\W3SVC1
- open the most recent txt file in the directory

Observe log entries for requests sourced from 192.168.1.133 and 192.168.1.134: these are requests SNAT'd by Azure Firewall instances.

# Scenario 3: SDWAN through NVA in Spoke

You will now connect an SD-WAN connection to the Cisco CSR1000v router in nva-vnet. The router will dynamically advertise SD-WAN remote IP space to the West Europe Hub via BGP.

![image](images/sd-wan.png)

# Scenario 4: Internet through Firewall in Spoke

# Close Out

