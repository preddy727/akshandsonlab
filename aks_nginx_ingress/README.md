# Nginx Ingress

| Parameter                    | Description                                                                | Default    |
| ---------------------------- | -------------------------------------------------------------------------- | ---------- |
| `ingress_class`              | The class used for routing multiple ingress controllers                    | nginx      |
| `use_internal_load_balancer` | Should this ingress use a internal or public load balancer                 | true       |
| `namespace_name`             | Namespace used to save helm release K8s Secret. (May not be used by chart) | extensions |

### Examples:

#### Ingress for internal traffic

```hcl

module "ingress_internal" {
  source     = "./modules/ingress_nginx"
  depends_on = [module.linkerd]
}

```

#### Ingress for public traffic

```hcl

module "ingress_public" {
  source                     = "./modules/ingress_nginx"
  use_internal_load_balancer = false
  depends_on                 = [module.linkerd]
}

```

#### Ingress for Both public and private traffic

```hcl

module "ingress_internal" {
  source                     = "./modules/ingress_nginx"
  use_internal_load_balancer = true
  depends_on                 = [module.linkerd]

}

module "ingress_public" {
  source                     = "./modules/ingress_nginx"
  use_internal_load_balancer = false
  ingress_class              = "nginx-pub"
  depends_on                 = [module.linkerd]
}

```

> **_NOTE:_** When using Multiple Ingress controllers you will need to make sure you set the correct ingress class in your ingress objects

```yaml hl_lines=6
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name:hello-ingress-internal
  annotations:
    kubernetes.io/ingress.class: nginx
  ... # removed for simplicity
```

```yaml hl_lines=6
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: hello-ingress-public
  annotations:
    kubernetes.io/ingress.class: nginx-pub
  ... # removed for simplicity
```

### Provider Setup:

Please add this provider to the providers defined in your root terraform.

You may need to update the value path to match your AKS path.

> **_Note:_** use `.kube_admin_config.` with RBAC and `.kube_config.` without.

```hcl

provider "helm" {
  kubernetes {
    load_config_file       = "false"
    host                   = azurerm_kubernetes_cluster.k8s.kube_admin_config.0.host
    username               = azurerm_kubernetes_cluster.k8s.kube_admin_config.0.username
    password               = azurerm_kubernetes_cluster.k8s.kube_admin_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.cluster_ca_certificate)
  }
}

```


#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement_helm) | ~> 2.1.2 |
| <a name="requirement_tls"></a> [tls](#requirement_tls) | >= 2.2.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | n/a |
| <a name="provider_helm"></a> [helm](#provider_helm) | ~> 2.1.2 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_aks_name"></a> [aks_name](#input_aks_name) | Specifies the name of the aks | `string` |
| <a name="input_autoscaling_enabled"></a> [autoscaling_enabled](#input_autoscaling_enabled) | Enable autoscaling, true or false. | `string` |
| <a name="input_chart_version"></a> [chart_version](#input_chart_version) | The version of the chart. | `string` |
| <a name="input_client_id"></a> [client_id](#input_client_id) | Azure service principal application Id | `any` |
| <a name="input_client_secret"></a> [client_secret](#input_client_secret) | Azure service principal application Secret | `any` |
| <a name="input_cluster_key"></a> [cluster_key](#input_cluster_key) | The map key for the AKS cluster. Used to indicate which AKS cluster should be used to authenticate. | `string` |
| <a name="input_create_namespace"></a> [create_namespace](#input_create_namespace) | Create the namespace if it does not yet exist. | `bool` |
| <a name="input_force_update"></a> [force_update](#input_force_update) | Force resource update through delete/recreate if needed. | `bool` |
| <a name="input_ingress_class"></a> [ingress_class](#input_ingress_class) | The name of the ingress class to route through this controller. | `string` |
| <a name="input_namespace_name"></a> [namespace_name](#input_namespace_name) | the namespace used to store the helm state secret object and the charts resources | `string` |
| <a name="input_release_name"></a> [release_name](#input_release_name) | The Name of the helm release | `string` |
| <a name="input_replace"></a> [replace](#input_replace) | Re-use the given name, even if that name is already used. This is unsafe in production. | `bool` |
| <a name="input_replica_count"></a> [replica_count](#input_replica_count) | The number of replicas to create. | `number` |
| <a name="input_repository"></a> [repository](#input_repository) | The URL of the chart repository. | `string` |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Specifies the name of the Resource Group | `string` |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | Azure subscription Id. | `any` |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id) | Azure tenant Id. | `any` |
| <a name="input_timeout"></a> [timeout](#input_timeout) | The timeout for the chart deployment by the Helm provider, in seconds. Default is 300 | `number` |
| <a name="input_use_internal_load_balancer"></a> [use_internal_load_balancer](#input_use_internal_load_balancer) | When true, an internal load balancer will be created | `bool` |

#### Outputs

No outputs.
