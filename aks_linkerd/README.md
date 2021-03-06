# Linkerd

>***_Note:_*** Linkerd has to be installed before any Nginx ingress controllers.

The Linkerd module is intend to install and configure Linkerd per AT&T CSO approval.

| Parameter                                    | Description                                  | Default           |
| -------------------------------------------- | -------------------------------------------- | ----------------- |
| `trust_anchor_cert_validity_period_hours`    | Number of hours the trust anchor is valid    | 175200 (20 years) |
| `identity_issuer_cert_validity_period_hours` | Number of hours the identity issuer is valid | 87600 (10 years)  |
| `bastion_proxy_port_number`                  | Port number used by the bastion proxy        | 3128              |

### Example

```hcl

Put code example for enabling aks_linkerd layer here...

```

#### **Inject proxy side-car**

Update namespace to have the `linkerd.io/inject: enabled` annotation.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: hello-world
  annotations:
    linkerd.io/inject: enabled
```

You will need to make sure that your Nginx ingress controller has the pod annotation to `linkerd.io/inject: enabled`

If you are using the **Nginx Ingress** module the annotation is added by default.

### **Provider Setup:**

Please add this provider to the providers defined in your root terraform.

You may need to update the value path to match your AKS cluster path.

> **_Note:_** use `.kube_admin_config.` with RBAC (the preferred choice & default) and `.kube_config.` without.

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
| <a name="requirement_helm"></a> [helm](#requirement_helm) | ~> 2.1.1 |
| <a name="requirement_tls"></a> [tls](#requirement_tls) | >= 2.2.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | n/a |
| <a name="provider_helm"></a> [helm](#provider_helm) | ~> 2.1.1 |
| <a name="provider_tls"></a> [tls](#provider_tls) | >= 2.2.0 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [helm_release.linkerd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [tls_cert_request.issuer_req](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.issuer_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.issuer_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.trustanchor_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.trustanchor_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_aks_name"></a> [aks_name](#input_aks_name) | Specifies the name of the aks | `string` |
| <a name="input_bastion_proxy_port_number"></a> [bastion_proxy_port_number](#input_bastion_proxy_port_number) | Port number used by the bastion proxy | `string` |
| <a name="input_chart"></a> [chart](#input_chart) | The name of the chart. | `string` |
| <a name="input_chart_version"></a> [chart_version](#input_chart_version) | The version of the chart. | `string` |
| <a name="input_client_id"></a> [client_id](#input_client_id) | Azure service principal application Id | `any` |
| <a name="input_client_secret"></a> [client_secret](#input_client_secret) | Azure service principal application Secret | `any` |
| <a name="input_cluster_key"></a> [cluster_key](#input_cluster_key) | The map key for the AKS cluster. Used to indicate which AKS cluster should be used to authenticate. | `string` |
| <a name="input_create_namespace"></a> [create_namespace](#input_create_namespace) | Create the namespace if it does not yet exist. | `bool` |
| <a name="input_force_update"></a> [force_update](#input_force_update) | Force resource update through delete/recreate if needed. | `bool` |
| <a name="input_identity_issuer_cert_validity_period_hours"></a> [identity_issuer_cert_validity_period_hours](#input_identity_issuer_cert_validity_period_hours) | Number of hours the identity issuer is valid Default: 87600 (10 years) | `number` |
| <a name="input_name"></a> [name](#input_name) | The name of the deployment. | `string` |
| <a name="input_namespace_name"></a> [namespace_name](#input_namespace_name) | the namespace used to store the helm state secret object and the charts resources | `string` |
| <a name="input_replace"></a> [replace](#input_replace) | Re-use the given name, even if that name is already used. This is unsafe in production. | `bool` |
| <a name="input_repository"></a> [repository](#input_repository) | The location of the repository. | `string` |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Specifies the name of the Resource Group | `string` |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | Azure subscription Id. | `any` |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id) | Azure tenant Id. | `any` |
| <a name="input_timeout"></a> [timeout](#input_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` |
| <a name="input_trust_anchor_cert_validity_period_hours"></a> [trust_anchor_cert_validity_period_hours](#input_trust_anchor_cert_validity_period_hours) | Number of hours the trust anchor is valid Default: 175200 (20 years) | `number` |

#### Outputs

No outputs.
