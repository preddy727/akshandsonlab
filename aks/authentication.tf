
#############################################################################
# Provider Authentication
#############################################################################

variable "subscription_id" {
  description = "Azure subscription Id."
  default = "c2483929-bdde-40b3-992e-66dd68f52928"
}

variable "tenant_id" {
  description = "Azure tenant Id."
  default = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

variable "client_id" {
 description = "Azure service principal application Id"
 default = null
}

variable "client_secret" {
  description = "Azure service principal application Secret"
  default = null
}
