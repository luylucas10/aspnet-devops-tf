terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">3"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.agent_count
    vm_size    = "Standard_B2s"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Test"
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  cleanup_on_fail  = true

  set = [{
    name  = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path\""
    value = "/healthz"
    },
    {
      name  = "controller.service.externalTrafficPolicy"
      value = "Local"
  }]

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  cleanup_on_fail  = true


  set = [{
    name  = "crds.enabled"
    value = "true"
  }]

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
