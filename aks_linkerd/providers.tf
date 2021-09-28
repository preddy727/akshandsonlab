# Helm provider for deployment of some modules (Linkerd, etc)

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.host
    username               = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.username
    password               = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.password
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate)
  }
}

terraform {
  required_version = "~> 1.0.0" 
 #  backend "azurerm" {}
  required_providers {
    helm = {
      version = "~> 2.1.1"
    }
    tls = {
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  # Whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  partner_id      = "a79fe048-6869-45ac-8683-7fd2446fc73c"

  features {}
}

