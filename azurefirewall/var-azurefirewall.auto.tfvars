resource_group_name = "aksdemo_rg"

firewalls = {
  "firewall1" = {
    name              = "aksfirewall2035"
    threat_intel_mode = ""
    ip_configurations = [{
      name                      = "aksfirewall2024"
      subnet_name               = "AzureFirewallSubnet"
      vnet_name                 = "aksdemo_vnet" #"jstartvmssfirst"
      networking_resource_group = "aksdemo_rg"
    }]
    public_ip_name = "firewallpip35"
    zones = ["1", "2", "3"]
    private_ip_ranges = ["0.0.0.0/0"]
  }
}

fw_network_rules = {
  "network_rule1" = {
    name         = "testalert"
    firewall_key = "firewall1"
    action       = "Allow"
    priority     = "200"
    rules = [{
      name                  = "test1"
      description           = "testrule"
      source_addresses      = ["52.168.0.138"]
      destination_ports     = ["22", "443"]
      destination_addresses = ["52.168.0.148"]
      protocols             = ["TCP"]
      },
      {
        name                  = "test2"
        description           = "testrule"
        source_addresses      = ["52.168.0.158"]
        destination_ports     = ["22", "443"]
        destination_addresses = ["52.168.0.168"]
        protocols             = ["TCP"]
    }]
  }
}

fw_nat_rules = {
  "nat_rule1" = {
    name         = "natrule1"
    firewall_key = "firewall1"
    priority     = "300"
    rules = [{
      name               = "test1"
      description        = "testrule"
      source_addresses   = ["52.168.0.138"]
      destination_ports  = ["22"]
      protocols          = ["TCP"]
      translated_address = "52.138.0.7"
      translated_port    = "443"
      },
      {
        name               = "test2"
        description        = "testrule"
        source_addresses   = ["52.168.0.158"]
        destination_ports  = ["22"]
        protocols          = ["TCP"]
        translated_address = "52.138.0.7"
        translated_port    = "443"
    }]
  }
}

fw_application_rules = {
  "app_rule1" = {
    name         = "apprule2"
    firewall_key = "firewall1"
    priority     = "300"
    action       = "Allow"
    rules = [{
      name             = "apptest10"
      description      = "testing rule"
      source_addresses = ["52.38.0.43"]
      fqdn_tags        = ["Azurebackup"]
      target_fqdns     = null
      protocol         = null
      },
      {
        name             = "apptest11"
        description      = "testing rule"
        source_addresses = ["52.38.0.43"]
        fqdn_tags        = null
        target_fqdns     = ["www.microsoft.com"]
        protocol = [{
          port = 443
          type = "Https"

        }]
    }]
  }
}

firewall_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
