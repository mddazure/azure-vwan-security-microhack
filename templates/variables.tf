variable "location-vwan" {
  description = "Location to deploy vwan"
  type        = string
  //default     = "swedencentral"
default = "westeurope"
}
variable "location-vwan-we-hub" {
  description = "Location to deploy we hub"
  type        = string
  //default     = "swedencentral"
default = "westeurope"
}
variable "location-vwan-useast-hub" {
  description = "Location to deploy we hub"
  type        = string
default = "eastus"
}
variable "location-spoke-1" {
  description = "Location to deploy spoke-1"
  type        = string
  //default     = "swedencentral"
default = "westeurope"
}
variable "location-spoke-2" {
  description = "Location to deploy spoke-2"
  type        = string
  //default     = "swedencentral"
default = "westeurope"
}
variable "location-spoke-3" {
  description = "Location to deploy spoke-3"
  type        = string
  default     = "EastUS"
}
variable "location-spoke-4" {
  description = "Location to deploy spoke-4"
  type        = string
  //default     = "WestUS2"
    default     = "EastUS"
}
variable "location-hub-1" {
  description = "Location to deploy hub-1"
  type        = string
  //default     = "swedencentral"
default = "westeurope"
}
variable "location-hub-2" {
  description = "Location to deploy hub-2"
  type        = string
  default     = "EastUS"
}
variable "location-onprem" {
  description = "Location to deploy onprem"
  type        = string
  default     = "uksouth"
}
variable "location-onprem2" {
  description = "Location to deploy onprem2"
  type        = string
  default     = "swedencentral"
  //default = "westeurope"
}
variable "location-onprem3" {
  description = "Location to deploy onprem2"
  type        = string
  default = "northeurope"
}
variable "location-spoke-services" {
  description = "Location to deploy spoke-services"
  type        = string
  //default     = "swedencentral"
default = "westeurope"
}
variable "username" {
  description = "Username for Virtual Machines"
  type        = string
  default     = "AzureAdmin"
}

variable "password" {
  description = "Virtual Machine password, must meet Azure complexity requirements"
   type        = string
   default     = "Microhack2023"
}
variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_D2s_v3"
}
variable "shutdown-time"{
  description = "Time to shutdown the VMs"
  default     = "1900"
}
