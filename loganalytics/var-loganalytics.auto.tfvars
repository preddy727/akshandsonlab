resource_group_name = "aksdemo_rg"

name              = "aksdemologanalytics93021"
sku               = "PerGB2018"
retention_in_days = 30
key_vault_name    = null

log_analytics_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
