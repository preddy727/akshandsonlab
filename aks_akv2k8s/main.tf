# data.terraform_remote_state.aks.outputs.aks
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
}



resource "helm_release" "azure-key-vault-to-k8s" {
  name       = var.deployment_name
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  replace    = var.replace
  timeout    = var.timeout
  create_namespace = var.create_namespace
  namespace = var.namespace_name

  values = [var.config_values]
}
