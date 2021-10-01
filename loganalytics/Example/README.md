# Create Log Analytics Workspace in Azure

This layer allows you to create log analytics workspace in azure.

## Features

- create log analytics workspace in a particular resource group

## usage

```yaml
- name: loganalytics
  type: loganalytics
  version: "0.5.0"
  skip: false
  destroy: false
  dependencies:
    adoprivateendpoints: adoprivateendpoints
    keyvault: keyvault
```

## Example

Please refer Example directory to consume this layer into your application.

- [var-loganalytics.auto.tfvars](./var-loganalytics.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the Log analytics layer.

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
     }))
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

# **Required Parameters**

These variables must be set in the `/Layers/<env>/var-loganalytics.auto.tfvars` file when using this layer.

## resource_group_name `string`

    Description: The name of the resource group in which the Log Analytics workspace will be created.

## name `string`

    Description: Specifies the name of the Key Vault. Changing this forces a new resource to be created.

# **Optional Parameters**

## retention_in_days `string`

    Description: The workspace data retention in days

### Note: allowed values - `range between 30 and 730`

## law_additional_tags `string`

    Description: A mapping of tags to assign to the resource.

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_log_analytics_workspace](https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html) <br />
