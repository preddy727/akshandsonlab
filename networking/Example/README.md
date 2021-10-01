# Create Base Infrastructure Resources in Azure

This layer allows you to create and manage the Azure Network Resources required for all applications.

## Features

This layer will:

- Create one or multiple Virtual Networks.
- Create one or multiple Subnets.

## Usage

```yaml
- name: networking
  type: networking
  version: "0.7.0"
  skip: false
  destroy: false
  dependencies:
    resourcegroup: resourcegroup
```

## Example

Please refer Example directory to consume this layer into your application.

- [var-networking.auto.tfvars](./var-networking.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the resource group layer.

## Best practices for variable declaration/defination

- All names of the Resources should be defined as per AT&T standard naming conventions.

- While declaring variables with data type 'map(object)' or 'object; or 'list(object)', It's mandatory to define all the attributes in object. If you don't want to set any attribute then define its value as null or empty list([]) or empty map({}) as per the object data type.

- Please make sure all the Required parameters are set. Refer below section to understand the required and optional input values when using this layer.

- Please verify that the values provided to the variables are in comfort with the allowed values for that variable. Refer below section to understand the allowed values for each variable when using this layer.

## Inputs

### **Required Parameters**

These variables must be set in the `/Layers/<env>/var-networking.auto.tfvars` file when using this layer.

#### resource_group_name `string`

    Description: Specifies the name of the resource group in which to create the Azure Network Base Infrastructure Resources.

#### net_location `string`

    Description: Specifies the Network resources location if different than the resource group's location.

#### virtual_networks `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Networks.

| Attribute            |  Data Type   | Field Type | Description                                                                                                                                        | Allowed Values |
| :------------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                 |    string    |  Required  | The name of the virtual network. Changing this forces a new resource to be created.                                                                |                |
| address_space        | list(string) |  Required  | The address space that is used the virtual network. You can supply more than one address space. Changing this forces a new resource to be created. |                |
| dns_servers          | list(string) |  Optional  | List of IP addresses of DNS servers                                                                                                                |                |
| ddos_protection_plan |  object({})  |  Optional  | Specifies the Network DDOS Protection Plan `ddos_protection_plan` Block as mentioned below.                                                        |                |

#### ddos_protection_plan

| Attribute | Data Type | Field Type | Description                                             | Allowed Values |
| :-------- | :-------: | :--------: | :------------------------------------------------------ | :------------- |
| id        |  string   |  Required  | The Resource ID of DDoS Protection Plan.                |                |
| enable    |   bool    |  Optional  | Enable/disable DDoS Protection Plan on Virtual Network. | true, false    |

#### vnet_peering `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Network Peering which allows resources to access other resources in the linked virtual network.

| Attribute                    | Data Type | Field Type | Description                                                                                                                                                                                                                                                                                                                                                                    | Allowed Values |
| :--------------------------- | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| destination_vnet_name        |  string   |  Required  | Specfies the Azure resource name of the remote virtual network. Changing this forces a new resource to be created.                                                                                                                                                                                                                                                             |                |
| destination_vnet_rg          |  string   |  Required  | The resource group name of the the remote virtual network.                                                                                                                                                                                                                                                                                                                     |                |
| vnet_key                     |  string   |  Required  | The key from the map of virtual networks specified in **_virtual_networks_** block. Specifies the name of source virtual network. Changing this forces a new resource to be created. Set this to null if referring the existing virtual network from the portal.                                                                                                               |                |
| vnet_name                    |  string   |  Optional  | Specifies the name of source virtual network. Changing this forces a new resource to be created. Required if referring the existing virtual network from the portal.                                                                                                                                                                                                           |                |
| allow_virtual_network_access |   bool    |  Optional  | Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true.                                                                                                                                                                                                                                                               | true, false    |
| allow_forwarded_traffic      |   bool    |  Optional  | Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false.                                                                                                                                                                                                                                                                            | true, false    |
| allow_gateway_transit        |   bool    |  Optional  | Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.                                                                                                                                                                                                                                                                           | true, false    |
| use_remote_gateways          |   bool    |  Optional  | Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false. | true, false    |

#### subnets `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Subnets.

| Attribute         |    Data Type     | Field Type | Description                                                                                                                                                                                                     | Allowed Values                                                                                                                                                                                       |
| :---------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name              |      string      |  Required  | The name of the subnet. Changing this forces a new resource to be created.                                                                                                                                      |                                                                                                                                                                                                      |
| vnet_key          |      string      |  Required  | The key from the map of virtual networks specified in **_virtual_networks_** block. Specifies the name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created. |                                                                                                                                                                                                      |
| address_prefixes  |   list(string)   |  Required  | The address prefixes to use for the subnet.                                                                                                                                                                     |                                                                                                                                                                                                      |
| pe_enable         |       bool       |  Optional  | Enable or Disable network policies for the private link endpoint and private link service on the subnet. Default value is false.                                                                                | true, false                                                                                                                                                                                          |
| service_endpoints |   list(string)   |  Optional  | The list of Service endpoints to associate with the subnet.                                                                                                                                                     | Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage , Microsoft.Web |
| delegation        | list(object({})) |  Optional  | Specfies One or more delegation blocks as defined below.                                                                                                                                                        |                                                                                                                                                                                                      |

#### delegation

| Attribute          |    Data Type     | Field Type | Description                                              | Allowed Values |
| :----------------- | :--------------: | :--------: | :------------------------------------------------------- | :------------- |
| name               |      string      |  Required  | A name for this delegation.                              |                |
| service_delegation | list(object({})) |  Required  | Specifies the service_delegation block as defined below. |                |

#### service_delegation

| Attribute |  Data Type   | Field Type | Description                                                                                                   | Allowed Values                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| :-------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| name      |    string    |  Required  | The name of service to delegate to.                                                                           | Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.DBforPostgreSQL/serversv2, Microsoft.HardwareSecuritylayers/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Web/hostingEnvironments , Microsoft.Web/serverFarms |
| actions   | list(string) |  Optional  | Specifies the list of Actions which should be delegated. This list is specific to the service to delegate to. | Microsoft.Network/networkinterfaces/\*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action , Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action                                                                                                                                                                                                                                              |

### **Optional Parameters**

#### net_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_virtual_network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html) <br />
[azurerm_virtual_network_peering](https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html) <br />
[azurerm_subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html) <br />
