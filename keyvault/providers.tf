# --------------------------------------------------------
# Setup
# --------------------------------------------------------

# Provider block -> please make sure you have added partner id

terraform {
  required_providers {
    azurerm = {
      version = "=2.67"
    }
    azuread = {
      version = "=1.6.0"
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

# Azure AD Provider
provider "azuread" {

  #subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Set the terraform backend
terraform {
  required_version = "~> 1.0.0"
  backend "azurerm" {} #Backend variables are initialized through the secret and variable folders
}
