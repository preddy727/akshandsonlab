# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group"
  default     = "preastus2-aksdemo-rg"
}

variable "aks_name" {
  type        = string
  description = "Specifies the name of the aks"
  default     = "preastus2-aksdemo-aks"
}

variable "deployment_name" {
  description = "The name of the deployment"
  type = string
  default = "azure-key-vault-to-k8s"
}

variable "chart_repository" {
  description = "The URL of the chart repository"
  type = string
  default = "http://charts.spvapi.no"
}

variable "chart_name" {
  description = "The name of the helm chart"
  type = string
  default = "akv2k8s"
}

variable "chart_version" {
  description = "the version of akv2k8s chart"
  type        = string
  default     = "2.0.11"
}

variable "replace" { 
  description = "replace or not"
  type = bool
  default = true
}

variable "timeout" {
  description = "Timeout value for deployment"
  type = number
  default = 300
}

variable "create_namespace" {
  description = "Create the namespace or not."
  type = bool
  default = true
}

variable "namespace_name" {
  description = "the namespace used to store the helm state secret object and the charts resources"
  type        = string
  default     = "extensions"
}

# example see: https://github.com/hashicorp/terraform-provider-helm/issues/564#issuecomment-677809450
variable "config_values"{
  description = "values used to override default values in the helm chart.  must be vaild ymal"
  type = string
  default = ""
}
