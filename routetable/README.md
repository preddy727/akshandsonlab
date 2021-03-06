#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement_azuread) | =1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | =2.67 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | =2.67 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/subnet_route_table_association) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/data-sources/resource_group) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_client_id"></a> [client_id](#input_client_id) | Azure service principal application Id | `any` |
| <a name="input_client_secret"></a> [client_secret](#input_client_secret) | Azure service principal application Secret | `any` |
| <a name="input_firewall_private_ips_map"></a> [firewall_private_ips_map](#input_firewall_private_ips_map) | Specifies the Map of Azure Firewall Private Ip's | `map(string)` |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | The name of the resource group in which to create the Route Tables. | `string` |
| <a name="input_route_tables"></a> [route_tables](#input_route_tables) | The route tables with their properties. | <pre>map(object({<br>    name                          = string<br>    disable_bgp_route_propagation = bool<br>    subnet_names                  = list(string)<br>    routes = list(object({<br>      name                   = string<br>      address_prefix         = string<br>      next_hop_type          = string<br>      next_hop_in_ip_address = string<br>      azure_firewall_name    = string<br>      <br>    }))<br>    tags = map(string)<br>  }))</pre> |
| <a name="input_rt_additional_tags"></a> [rt_additional_tags](#input_rt_additional_tags) | Additional Route Table resources tags, in addition to the resource group tags. | `map(string)` |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids) | A map of subnet id's | `map(string)` |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | Azure subscription Id. | `any` |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id) | Azure tenant Id. | `any` |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_ids"></a> [route_table_ids](#output_route_table_ids) | n/a |
| <a name="output_rt_ids_map"></a> [rt_ids_map](#output_rt_ids_map) | n/a |
