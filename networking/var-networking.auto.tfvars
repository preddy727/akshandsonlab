resource_group_name = "aksdemo_rg"
net_location        = null

virtual_networks = {
  virtualnetwork1 = {
    name                 = "aksdemo_vnet"
    address_space        = ["10.0.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  },
  virtualnetwork2 = {
    name                 = "aksdemo_vnet2"
    address_space        = ["172.16.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

vnet_peering = {}

subnets = {
  subnet1 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "aksdemo_vnet"
    name              = "loadbalancer"
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    pe_enable         = false
    delegation        = []
  },
  subnet2 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "aksdemo_vnet"
    name              = "pesubnet"
    address_prefixes  = ["10.0.2.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet3 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "aksdemo_vnet"
    name              = "application"
    address_prefixes  = ["10.0.3.0/24"]
    pe_enable         = false
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    delegation        = []
  },
  subnet4 = {
    vnet_key          = "virtualnetwork2"
    vnet_name         = "aksdemo_vnet2"
    name              = "applicationgateway"
    address_prefixes  = ["172.16.0.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet5 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "aksdemo_vnet"
    name              = "AzureFirewallSubnet"
    address_prefixes  = ["10.0.4.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
 subnet6 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "aksdemo_vnet"
    name              = "proxy"
    address_prefixes  = ["10.0.5.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
 subnet7 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = "aksdemo_vnet"
    name              = "aks"
    address_prefixes  = ["10.0.6.0/24"]
    service_endpoints = null
    pe_enable         = false
    delegation        = []
  },
}

net_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
