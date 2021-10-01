# Create Resource Group in Azure

This layer allows you to create and manage Resource Group in Microsoft Azure.

## Features

This layer will:

- Create new Resource Group in Microsoft Azure.

## Usage

```yaml
- name: resourcegroup
  type: resourcegroup
  version: "3.0.0"
  skip: false
  provider: terraform
  destroy: false
```

## Example

Please refer Example directory to consume this layer into your application.

- [var-resourcegroup.auto.tfvars](./var-resourcegroup.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the resource group layer.

## Best practices for variable declaration/defination

- All names of the Resources should be defined as per AT&T standard naming conventions.

- While declaring variables with data type 'map(object)' or 'object; or 'list(object)', It's mandatory to define all the attributes in object. If you don't want to set any attribute then define its value as null or empty list([]) or empty map({}) as per the object data type.

- Please make sure all the Required parameters are set. Refer below section to understand the required and optional input values when using this layer.

- Please verify that the values provided to the variables are in comfort with the allowed values for that variable. Refer below section to understand the allowed values for each variable when using this layer.

## Inputs

### **Required Parameters**

These variables must be set in the `/Layers/<env>/var-resourcegroup.auto.tfvars` file when using this layer.

#### name `string`

    Description: The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created.

#### location `string`

    Description: The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.

#### tags `map(string)`

    Description: A mapping of tags which should be assigned to the Resource Group.

    Default: {}

## Outputs

#### resource_group_name

    Description: The Name of the Resource Group.

#### resource_group_location

    Description: The Azure Region of the Resource Group.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_resource_group](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html)
