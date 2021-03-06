# [akv2k8s](https://akv2k8s.io/)

Azure Key Vault to Kubernetes [(akv2k8s)](https://akv2k8s.io/) makes Azure Key Vault secrets, certificates and keys available in Kubernetes and/or your application - in a simple and secure way.

| Parameter           | Description                                                              | Default          |
| ------------------- | ------------------------------------------------------------------------ | ---------------- |
| `namespace_name`    | Namespace used to save helm release                                      | extensions       |


### **Example:**

```hcl



module "akv2k8s" {
  source         = "./modules/akv2k8s"
}

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
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.12.31 |
| <a name="requirement_helm"></a> [helm](#requirement_helm) | ~> 1.2.4 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider_helm) | ~> 1.2.4 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [helm_release.azure-key-vault-to-k8s](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_chart_name"></a> [chart_name](#input_chart_name) | The name of the helm chart | `string` |
| <a name="input_chart_repository"></a> [chart_repository](#input_chart_repository) | The URL of the chart repository | `string` |
| <a name="input_chart_version"></a> [chart_version](#input_chart_version) | the version of akv2k8s chart | `string` |
| <a name="input_client_id"></a> [client_id](#input_client_id) | Azure service principal application Id | `any` |
| <a name="input_client_secret"></a> [client_secret](#input_client_secret) | Azure service principal application Secret | `any` |
| <a name="input_config_values"></a> [config_values](#input_config_values) | values used to override default values in the helm chart.  must be vaild ymal | `string` |
| <a name="input_create_namespace"></a> [create_namespace](#input_create_namespace) | Create the namespace or not. | `bool` |
| <a name="input_deployment_name"></a> [deployment_name](#input_deployment_name) | The name of the deployment | `string` |
| <a name="input_namespace_name"></a> [namespace_name](#input_namespace_name) | the namespace used to store the helm state secret object and the charts resources | `string` |
| <a name="input_replace"></a> [replace](#input_replace) | replace or not | `bool` |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | Azure subscription Id. | `any` |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id) | Azure tenant Id. | `any` |
| <a name="input_timeout"></a> [timeout](#input_timeout) | Timeout value for deployment | `number` |

#### Outputs

No outputs.
