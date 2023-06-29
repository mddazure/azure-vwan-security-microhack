# Introduction
This MicroHack demontrates the newly released [Routing Intent and Routing Policies](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies) capabilities in Azure Virtual WAN. It is a sequel to [Routing in Azure Virtual WAN MicroHack](https://github.com/mddazure/azure-vwan-microhack), and it is recommended to complete Scenario's 1 - 3 of that MicroHack before starting this one.

# Objectives
After completing this MicroHack you will:
- Understand traffic flow control through Secured Hubs with Azure Firewall 
- Know how to enable Routing Intent and Private and Internet Routing Policies
- Know how to leverage the Hub BGP capability to enable an NVA in a spoke


# Lab

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
  
  `cd ./azure-vwan-security-microhack`
  - Initialize terraform and download the azurerm resource provider:

  `terraform init`

- Now start the deployment (when prompted, confirm with **yes** to start the deployment):
 
  `terraform apply`

Deployment takes approximately 30 minutes. 


# Scenario 1