# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_key" {
  type = string
  description = "The map key for the AKS cluster. Used to indicate which AKS cluster should be used to authenticate."
  default = "aks1"
}

variable "name" {
  description = "The name of the deployment."
  type = string
  default = "linkerd2"
}

variable "repository" {
  description = "The location of the repository."
  type = string
  default = "https://helm.linkerd.io/stable"
}

variable "chart" {
  description = "The name of the chart."
  type = string
  default = "linkerd2"
}

variable "chart_version" {
  description = "The version of the chart."
  type = string
  default = "2.10.2"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation"
  type = number
  default = 300
} 

variable "namespace_name" {
  description = "the namespace used to store the helm state secret object and the charts resources"
  type        = string
  default     = "default"
}

variable "replace" {
  description = "Re-use the given name, even if that name is already used. This is unsafe in production."
  type = bool
  default = false
}

variable "create_namespace" {
  description = "Create the namespace if it does not yet exist."
  type = bool
  default = false
}

variable "force_update" {
  description = "Force resource update through delete/recreate if needed."
  type = bool
  default = false
}

variable "trust_anchor_cert_validity_period_hours" {
  description = "Number of hours the trust anchor is valid Default: 175200 (20 years)"
  type        = number
  default     = 175200
}

variable "identity_issuer_cert_validity_period_hours" {
  description = "Number of hours the identity issuer is valid Default: 87600 (10 years)"
  type        = number
  default     = 87600
}

variable "bastion_proxy_port_number" {
  description = "Port number used by the bastion proxy"
  type        = string
  default     = "3128"
}

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

