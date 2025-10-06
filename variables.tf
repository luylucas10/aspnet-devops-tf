variable "resource_group_name" {
  default = "azgroup"
}

variable "location" {
  default = "westus2"
}

variable "aks_cluster_name" {
  default = "azgroup-aks"
}

variable "dns_prefix" {
  default = "azgroup-aks"
}

variable "agent_count" {
  default = 1
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type      = string
  sensitive = true
}
