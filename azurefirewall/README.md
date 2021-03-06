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
| [azurerm_firewall.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/firewall) | resource |
| [azurerm_firewall_application_rule_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/firewall_application_rule_collection) | resource |
| [azurerm_firewall_nat_rule_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/firewall_nat_rule_collection) | resource |
| [azurerm_firewall_network_rule_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/resources/public_ip) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.67/docs/data-sources/subnet) | data source |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_ackey"></a> [ackey](#input_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` |
| <a name="input_client_id"></a> [client_id](#input_client_id) | Azure service principal application Id | `any` |
| <a name="input_client_secret"></a> [client_secret](#input_client_secret) | Azure service principal application Secret | `any` |
| <a name="input_firewall_additional_tags"></a> [firewall_additional_tags](#input_firewall_additional_tags) | Additional tags for the Azure Firewall resources, in addition to the resource group tags. | `map(string)` |
| <a name="input_firewalls"></a> [firewalls](#input_firewalls) | The Azure Firewalls with their properties. | <pre>map(object({<br>    name              = string<br>    threat_intel_mode = string<br>    ip_configurations = list(object({<br>      name                      = string<br>      subnet_name               = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>    }))<br>    public_ip_name = string<br>    zones = list(string)<br>    private_ip_ranges = list(string)<br>  }))</pre> |
| <a name="input_fw_application_rules"></a> [fw_application_rules](#input_fw_application_rules) | The Azure Firewall Application Rules with their properties. | <pre>map(object({<br>    name         = string<br>    firewall_key = string<br>    priority     = number<br>    action       = string<br>    rules = list(object({<br>      name             = string<br>      description      = string<br>      source_addresses = list(string)<br>      fqdn_tags        = list(string)<br>      target_fqdns     = list(string)<br>      protocol = list(object({<br>        port = number<br>        type = string<br>      }))<br>    }))<br>  }))</pre> |
| <a name="input_fw_nat_rules"></a> [fw_nat_rules](#input_fw_nat_rules) | The Azure Firewall Nat Rules with their properties. | <pre>map(object({<br>    name         = string<br>    firewall_key = string<br>    priority     = number<br>    rules = list(object({<br>      name               = string<br>      description        = string<br>      source_addresses   = list(string)<br>      destination_ports  = list(string)<br>      protocols          = list(string)<br>      translated_address = string<br>      translated_port    = number<br>    }))<br>  }))</pre> |
| <a name="input_fw_network_rules"></a> [fw_network_rules](#input_fw_network_rules) | The Azure Firewall Rules with their properties. | <pre>map(object({<br>    name         = string<br>    firewall_key = string<br>    priority     = number<br>    action       = string<br>    rules = list(object({<br>      name                  = string<br>      description           = string<br>      source_addresses      = list(string)<br>      destination_ports     = list(string)<br>      destination_addresses = list(string)<br>      protocols             = list(string)<br>    }))<br>  }))</pre> |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Name of the resource group in which Firewall needs to be created | `string` |
| <a name="input_subscription_id"></a> [subscription_id](#input_subscription_id) | Azure subscription Id. | `any` |
| <a name="input_tenant_id"></a> [tenant_id](#input_tenant_id) | Azure tenant Id. | `any` |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_ids"></a> [firewall_ids](#output_firewall_ids) | n/a |
| <a name="output_firewall_ips_map"></a> [firewall_ips_map](#output_firewall_ips_map) | n/a |
| <a name="output_firewall_names"></a> [firewall_names](#output_firewall_names) | n/a |
| <a name="output_firewall_private_ips"></a> [firewall_private_ips](#output_firewall_private_ips) | n/a |
| <a name="output_firewall_public_ips"></a> [firewall_public_ips](#output_firewall_public_ips) | n/a |
