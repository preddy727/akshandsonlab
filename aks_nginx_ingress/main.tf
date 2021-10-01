# data.terraform_remote_state.aks.outputs.aks
data "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
}
resource "helm_release" "ingress_nginx" {
  name       = var.release_name
  repository = var.repository
  chart      = "ingress-nginx"
  version = var.chart_version
  timeout = var.timeout

  namespace = var.namespace_name
  create_namespace = var.create_namespace

  set {
    name = "controller.ingressClass"
    value = var.ingress_class
  }

  set {
    name  = "controller.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "controller.autoscaling.enabled"
    value = var.autoscaling_enabled
  }

  set {
    name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "controller.podAnnotations.linkerd\\.io/inject"
    value = "enabled"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = var.use_internal_load_balancer
    type  = "string"
  }

  set {
    name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }
}
