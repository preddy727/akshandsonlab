# Create Route table in Azure.

    This Module allows you to create multiple route tables in azure.

## Features

1.  Create one or multiple route tables in Azure.
2.  Associate route table to multiple subnets.
3.  Feasability to add private ip address of azure firewall in routes




## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)'. It's mandatory to define all the objects. If you don't want to use any specific objects define it as null or empty list as per the object data type.

    - for example:

    ```hcl
     variable "example" {
       type         = map(object({
       name         = string
       permissions  = list(string)
       cmk_enable   = bool
       auto_scaling = string
     }))
    ```

    - In above example, if you don't want to use the objects permissions and auto_scaling, you can define it as below.

    ```hcl
     example = {
       name          = "example"
       permissions   = []
       auto_scaling  = null
     }
    ```

3.  Please make sure all the Required parameters are declared. Refer below section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

#### resource_group_name `string`

    The name of the resource group in which storage account will be created.

#### route_tables `map(object({}))`

    Map of route table which needs to be created in a resource group

| Attribute       | Data Type  | Field Type | Description                                                                                                                                                                                                               | Allowed Values                                                    |
| :-------------- | :--------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------- |
| name            |   string   |  Required  | Name of route table   |  NA   |
| disable_bgp_route_propagation |   bool  |  optional | Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable |   NA     |
| subnet_names |   list(string)  |  Required | names of the subnets to which route table to be associated with |   NA  |
| tags  |  map(string)  |  Required | map of tags |    NA    |
| routes  |  list(objects({}))  |  Required | list of routes |    NA    |

#### routes `list(objects({}))`


| Attribute       | Data Type  | Field Type | Description                                                                                                                                                                                                               | Allowed Values                                                    |
| :-------------- | :--------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------- |
| name            |   string   |  Required  | Name of route   |  NA   |
| address_prefix  |   string   |  Required  | Destination address prefix  |  NA   | 
| next_hop_type   |   string   |  Required  | The type of Azure hop the packet should be sent to  |  VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None |
| next_hop_in_ip_address  |   string   |  Optional  | Contains the IP address packets should be forwarded to, Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |  NA   |



## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_route_table](https://www.terraform.io/docs/providers/azurerm/r/route_table.html) <br />
