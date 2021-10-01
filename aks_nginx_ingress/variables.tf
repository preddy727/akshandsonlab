# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "cluster_key" {
  type = string
  description = "The map key for the AKS cluster. Used to indicate which AKS cluster should be used to authenticate."
  default = "aks1"
}

variable "repository" {
  description = "The URL of the chart repository."
  type = string
  default = "https://kubernetes.github.io/ingress-nginx"  
}

variable "chart_version" {
  description = "The version of the chart."
  type = string
  default = "3.31.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "timeout" {
  description = "The timeout for the chart deployment by the Helm provider, in seconds. Default is 300"
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

variable "release_name" {
  description = "The Name of the helm release"
  type        = string
  default = "nginx-ingress-controller"
}

variable "ingress_class" {
  description = "The name of the ingress class to route through this controller."
  type        = string
  default     = "nginx"
}

variable "replica_count" {
  description = "The number of replicas to create."
  type = number
  default = 2
}

variable "autoscaling_enabled" {
  description = "Enable autoscaling, true or false."
  type = string # yep it's true/false as a string, that's what the source had. Don't blame me. 
  default = "true"
}

variable "use_internal_load_balancer" {
  description = "When true, an internal load balancer will be created"
  type        = bool # this one's bool, the other was a string, that's how it was when I got it... 
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group"
}

variable "aks_name" {
  type        = string
  description = "Specifies the name of the aks"
}