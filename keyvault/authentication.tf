
#############################################################################
# Provider Authentication
#############################################################################

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "client_id" {
 description = "Azure service principal application Id"
 default = null
}

variable "client_secret" {
  description = "Azure service principal application Secret"
  default = null
}