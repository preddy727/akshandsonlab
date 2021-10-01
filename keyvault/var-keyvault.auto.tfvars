resource_group_name = "aksdemo_rg"

name                            = "aksdemokeyvault93021"
enabled_for_deployment          = null
enabled_for_disk_encryption     = null
enabled_for_template_deployment = null
soft_delete_enabled             = true
purge_protection_enabled        = true
sku_name                        = "standard"
secrets                         = {}
access_policies                 = {}
network_acls                    = null

# The value below is REQUIRED when using MSI rather than SPN. 
msi_object_id = "ff336863-8f96-45bf-83f1-2b844755a7e6"

kv_additional_tags = {
  pe_enable    = true
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
