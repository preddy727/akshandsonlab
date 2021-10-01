# Create Azure Firewalls in Azure

This layer allows you to create one or multiple Azure Firewalls.

## Features

1. Create onr or multiple Azure Firewalls in Azure.
2. Create Network rules in Azure FIrewall
3. Create NAT rules in Azure Firewall.
4. Create Application rules in Azure Firewall.

## usage

```yaml
- name: azurefirewall
  type: azurefirewall
  version: "1.0.0"
  skip: false
  destroy: false
  dependencies:
    networking: networking
```

## Example

Please refer Example directory to consume this layer into your application.

- [var-azurefirewall.auto.tfvars](./var-azurefirewall.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the AzureFirewall layer.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)'. It's mandatory to define all the objects.If you don't want to use any specific objects define it as null or empty list as per the object data type.

    - for example:

    ```hcl
     variable "example" {
        type = map(object({
          name         = string
          permissions  = list(string)
          cmk_enable   = bool
          auto_scaling = string
        })
    )
    ```

    - In above example, if you don't want to use the objects permissions and auto_scaling, you can define it as below.

    ```hcl
      example = {
         name         = "example"
         permissions  = []
         cmk_enable   = true
         auto_scaling = null
      }
    ```

3.  Please make sure all the Required parameters are declared.Refer below
    section to understand the required and optional parameters of this layer.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

These variables must be set in the `/Layers/<env>/var-azurefirewall.auto.tfvars` file when using this layer.

#### resource_group_name `string`

    The name of the resource group in which Azure Firewall will be created.

#### firewalls `map(object({}))`

    Map of Azure Firewalls

| Attribute         |    Data Type     | Field Type | Description                                                                   | Allowed Values      |
| :---------------- | :--------------: | :--------: | :---------------------------------------------------------------------------- | :------------------ |
| name              |      string      |  Required  | Name of the AzureFirewall                                                     |                     |
| threat_intel_mode |      string      |  Optional  | The operation mode for threat intelligence-based filtering. Defaults to Alert | Off, Alert and Deny |
| ip_configurations | list(object({})) |  Required  | List of `ip_configuration` blocks as defined below                            |                     |
| public_ip_name    |      string      |  Required  | The Name of the Public IP Address associated with the firewall.               |                     |

#### ip_configuration `list(object({}))`

| Attribute   | Data Type | Field Type | Description                                                                                                                           | Allowed Values |
| :---------- | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------ | :------------- |
| name        |  string   |  Required  | Name of the ip configuration                                                                                                          |                |
| subnet_name |  string   |  Required  | Subnet name in which firewall should be deployed. it must have the name AzureFirewallSubnet and the subnet mask must be at least /26. |                |
| vnet_name   |  string   |  Required  | VNet name in which firewall should be deployed. it must have the name AzureFirewallSubnet and the subnet mask must be at least /26.   |                |

## **Optional Parameters**

#### firewall_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Azure Firewall resources tags, in addition to the resource group tags.

    Default: {}

#### fw_network_rules `map(object({}))`

    Map of Network rules in Azure Firewall

| Attribute    |    Data Type     | Field Type | Description                                                  | Allowed Values                          |
| :----------- | :--------------: | :--------: | :----------------------------------------------------------- | :-------------------------------------- |
| name         |      string      |  Required  | Name of the Network rule                                     |                                         |
| firewall_key |      string      |  Required  | key name of Azure Firewall                                   |                                         |
| priority     |      string      |  Required  | Specifies the priority of the rule collection                | Possible values are between 100 - 65000 |
| action       |      string      |  Required  | Specifies the action the rule will apply to matching traffic | Possible values are Allow and Deny.     |
| rules        | list(object({})) |  Required  | one or more **_rules_** block as defined below               |                                         |

#### rules `list(object({}))`

| Attribute             |  Data Type   | Field Type | Description                                         | Allowed Values         |
| :-------------------- | :----------: | :--------: | :-------------------------------------------------- | :--------------------- |
| name                  |    string    |  Required  | Name of the rule                                    |                        |
| description           |    string    |  Optional  | Specifies a description for the rule                |                        |
| source_addresses      | list(string) |  Required  | A list of source IP addresses and/or IP ranges      |                        |
| destination_addresses | list(string) |  Required  | A list of destination IP addresses and/or IP ranges |                        |
| destination_ports     | list(string) |  Required  | A list of destination ports.                        |                        |
| protocols             | list(string) |  Required  | A list of protocols                                 | Any, ICMP, TCP and UDP |

#### fw_nat_rules `map(object({}))`

    Map of nat rules in Azure Firewall

| Attribute    |    Data Type     | Field Type | Description                                    | Allowed Values                          |
| :----------- | :--------------: | :--------: | :--------------------------------------------- | :-------------------------------------- |
| name         |      string      |  Required  | Name of the NAT rule                           |                                         |
| firewall_key |      string      |  Required  | key name of Azure Firewall                     |                                         |
| priority     |      string      |  Required  | Specifies the priority of the rule collection  | Possible values are between 100 - 65000 |
| rules        | list(object({})) |  Required  | one or more **_rules_** block as defined below |                                         |

#### rules `list(object({}))`

| Attribute          |  Data Type   | Field Type | Description                                    | Allowed Values |
| :----------------- | :----------: | :--------: | :--------------------------------------------- | :------------- |
| name               |    string    |  Required  | Name of the rule                               |                |
| description        |    string    |  Optional  | Specifies a description for the rule           |                |
| source_addresses   | list(string) |  Required  | A list of source IP addresses and/or IP ranges |                |
| destination_ports  | list(string) |  Required  | A list of destination ports.                   |                |
| protocols          | list(string) |  Required  | A list of protocols                            | TCP,UDP        |
| translated_address |    string    |  Required  | The address of the service behind the Firewall |                |
| translated_port    |    string    |  Required  | The port of the service behind the Firewall.   |                |

#### fw_application_rules `map(object({}))`

    Map of application rules in Azure Firewall

| Attribute    |    Data Type     | Field Type | Description                                                  | Allowed Values                          |
| :----------- | :--------------: | :--------: | :----------------------------------------------------------- | :-------------------------------------- |
| name         |      string      |  Required  | Name of the Network rule                                     |                                         |
| firewall_key |      string      |  Required  | key name of Azure Firewall                                   |                                         |
| priority     |      string      |  Required  | Specifies the priority of the rule collection                | Possible values are between 100 - 65000 |
| action       |      string      |  Required  | Specifies the action the rule will apply to matching traffic | Possible values are Allow and Deny.     |
| rules        | list(object({})) |  Required  | one or more **_rules_** block as defined below               |                                         |

#### rules `list(object({}))`

| Attribute        |  Data Type   |    Field Type    | Description                                        | Allowed Values                                                                                             |
| :--------------- | :----------: | :--------------: | :------------------------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| name             |    string    |     Required     | Name of the rule                                   |                                                                                                            |
| description      |    string    |     Optional     | Specifies a description for the rule               |                                                                                                            |
| source_addresses | list(string) |     Required     | A list of source IP addresses and/or IP ranges     |                                                                                                            |
| fqdn_tags        |    string    |     Required     | A list of FQDN tags.                               | AppServiceEnvironment, AzureBackup, MicrosoftActiveProtectionService, WindowsDiagnostics and WindowsUpdate |
| target_fqdns     | list(string) |     Optional     | A list of target fqdns                             |                                                                                                            |
| protocol         |    string    | list(object({})) | one or more **_protocol_** blocks as defined below |                                                                                                            |

#### protocol `list(object({}))`

| Attribute | Data Type | Field Type | Description                       | Allowed Values        |
| :-------- | :-------: | :--------: | :-------------------------------- | :-------------------- |
| port      |  string   |  Optional  | Specify a port for the connection |                       |
| type      |  string   |  Required  | Specifies the type of connection  | Http, Https and Mssql |

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_firewall](https://www.terraform.io/docs/providers/azurerm/r/firewall.html) <br />
[azurerm_firewall_application_rule_collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_application_rule_collection.html) <br />
[azurerm_firewall_nat_rule_collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_nat_rule_collection.html) <br />
[azurerm_firewall_network_rule_collection](https://www.terraform.io/docs/providers/azurerm/r/firewall_network_rule_collection.html)
