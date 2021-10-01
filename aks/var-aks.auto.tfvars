resource_group_name ="aksdemo_rg"

aks_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}

# - AKS
aks_clusters = {
  "aks1" = {
    name                            = "jstartaksdev08252021ab"
    sku_tier                        = "Free"
    dns_prefix                      = "jstartaksdev08252021ab"
    kubernetes_version              = "1.19.11" #"1.19.9"
    docker_bridge_cidr              = "172.17.0.1/16"
    service_address_range           = "10.0.16.0/24"
    dns_ip                          = "10.0.16.2"
    admin_group_object_ids          = ["ea31a15d-2429-4a4d-8d82-bc1c5d113a8c"]
    rbac_enabled                    = true
    managed                         = true
    cmk_enabled                     = false
    assign_identity                 = true
    auto_scaler_profile             = null
    admin_username                  = "aksadminuser"
    api_server_authorized_ip_ranges = null
    network_plugin                  = null
    network_policy                  = null
    pod_cidr                        = null
    aks_default_pool = {
      name                      = "jstartaks"
      vm_size                   = "Standard_B2ms"
      availability_zones        = [1, 2, 3]
      enable_auto_scaling       = true
      max_pods                  = 30
      os_disk_size_gb           = 30
      subnet_id                 = "/subscriptions/c2483929-bdde-40b3-992e-66dd68f52928/resourceGroups/aksdemo_rg/providers/Microsoft.Network/virtualNetworks/aksdemo_vnet/subnets/aks"
      node_count                = 1
      min_count                 = 1
      max_count                 = 1
      orchestrator_version      = "1.19.9" # k8s version for node pool
      node_labels               = null # example, {nodepool : "system"}
      node_taints               = null # example, ["CriticalAddonsOnly=true:NoSchedule"]
      ## Information on use of node taints can be found here: 
      ## https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
    }
    load_balancer_profile = null
    kube_dashboard_enabled      = false
  }
}

# aks_extra_node_pools = {
#   np1 = {
#     name                      = "jstartaksnp"
#     aks_key                   = "aks1"
#     vm_size                   = "Standard_B2ms"
#     availability_zones        = [1, 2, 3]
#     enable_auto_scaling       = true
#     max_pods                  = 30
#     mode                      = null
#     os_disk_size_gb           = 30
#     subnet_name               = "akscluster"
#     vnet_name                 = "virtualnetwork1" #null #"jstartaksdevfirst"
#     networking_resource_group = "[__networking_resource_group_name__]"
#     node_count                = 1
#     max_count                 = 1
#     min_count                 = 1
#     orchestrator_version      = "1.19.9" # k8s version for node pool
#     node_labels               = null # example, {nodepool : "system"}
#     node_taints               = null # example, ["CriticalAddonsOnly=true:NoSchedule"]
#     ## Information on use of node taints can be found here: 
#     ## https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
#   }
# }

loganalytics_workspace_name = "aksdemologanalytics93021"
key_vault_name              = "aksdemokeyvault93021"

# - Private DNS for ADO agent connectivity
ado_subscription_id             = "c2483929-bdde-40b3-992e-66dd68f52928"
ado_aks_private_endpoint_name   = "jstartaksdev08252021abaks"
ado_subnet_name                 = "myDockerVMSubnet"
ado_vnet_name                   = "myDockerVMVNET"
ado_aks_private_connection_name = "adotoakspcn"
ado_resource_group_name         = "preastus2-adodemo-rg"
#ado_private_dns_vnet_link_name  = "jstartaksdev08252021a-aks"

# Azure container registry & PE info
acr_name                    =  "prreddydevdevopsacr"
acr_resource_group_name     = "preastus2-adodemo-rg"
acr_rg_location             = "eastus2"
acr_subnet_name             = "myDockerVMSubnet"
acr_vnet_name               = "myDockerVMVNET"
acr_pe_name                 = "jstartaksdev08252021a-acr"
pe_acr_record_name          = "adobaseinfra" #"jskacr06262021"
pe_acr_vnetlink_name        = "jstartaksdev08252021a-acr"
acr_private_connection_name = "jstartaksdev08252021a-acr"

# Legacy AAD RBAC
#  
# if ad_enabled = true is set above, the variables below ONLY need values if managed = false

# ###  Start AD integration config variables
# # Base Key Vault where the information will client app id , server app id and 
#mgmt_key_vault_name = "[__key_vault_name__]" # "base-infra-aks-kv" #"[__key_vault_name__]3"  
#mgmt_key_vault_rg   = "[__resource_group_name__]" # "base-infra-aks-rg" #"jstart-aks-08252021a-dev3" # 

# # secret name of objects stored in the key vault, only needed for Legacy AAD RBAC / non-managed
#aks_client_app_id     = "aks-client-app-id3"
#aks_server_app_id     = "aks-server-app-id3"
#aks_server_app_secret = "aks-server-app-secret3" # [SuppressMessage("Microsoft.Security", "CS001:SecretInline", Justification="Not an actual password")] 

# # attributes used to PE to Key Vault, as above, only needed for Legacy AAD RBAC / non-managed
#kv_resource_id = "/subscriptions/[__ado_subscription_id__]/resourceGroups/base-infra-aks-rg/providers/Microsoft.KeyVault/vaults/base-infra-aks-kv"
#pe_kv_name     = "[__key_vault_name__]3"

# ###  END AAD RBAC integration config variables 

# # If assign_identity = false, you need to supply the values below:
aks_client_id     = null
aks_client_secret = null
