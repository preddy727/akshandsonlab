data "azurerm_resource_group" "this" {
  name  = var.resource_group_name
}

locals {
  tags                       = merge(var.firewall_additional_tags, data.azurerm_resource_group.this.tags)
  
  ip_config_subnets_list = flatten([
    for fw_k, fw_v in var.firewalls : [
      for config in coalesce(fw_v.ip_configurations, []) : {
        key                       = format("%s_%s", fw_k, config.name)
        subnet_name               = config.subnet_name
        vnet_name                 = config.vnet_name
        networking_resource_group = config.networking_resource_group
      } if(config.subnet_name != null && config.vnet_name != null)
    ]
  ])
}

data "azurerm_subnet" "this" {
  for_each             = { for x in local.ip_config_subnets_list : x.key => x }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_public_ip" "this" {
  for_each            = var.firewalls
  name                = each.value.public_ip_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = local.tags
}

resource "azurerm_firewall" "this" {
  for_each            = var.firewalls
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  threat_intel_mode   = lookup(each.value, "threat_intel_mode", null)

  zones               = each.value["zones"]
  private_ip_ranges   = each.value["private_ip_ranges"]  
  
  dynamic "ip_configuration" {
    for_each = coalesce(lookup(each.value, "ip_configurations"), [])
    content {
      name                 = ip_configuration.value.name
      #subnet_id            = lookup(data.azurerm_subnet.this, "${each.key}_${ip_configuration.value.name}")["id"]
      # data.azurerm_subnet.this["${each.key}_${ip_configuration.value.subnet_name}"]["id"] -- lookup(data.azurerm_subnet.this, "${each.key}_${frontend_ip_configuration.value.name}")["id"]
      subnet_id            = lookup(data.azurerm_subnet.this, "${each.key}_${ip_configuration.value.name}")["id"]
      public_ip_address_id = lookup(azurerm_public_ip.this, each.key)["id"]
    }
  }

  tags       = local.tags
  depends_on = [azurerm_public_ip.this]

 
}

resource "azurerm_firewall_network_rule_collection" "this" {
  for_each            = var.fw_network_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = lookup(azurerm_firewall.this, each.value["firewall_key"])["name"]
  priority            = each.value["priority"]
  action              = each.value["action"]

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }

  depends_on = [azurerm_firewall.this]
}

resource "azurerm_firewall_nat_rule_collection" "this" {
  for_each            = var.fw_nat_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = lookup(azurerm_firewall.this, each.value["firewall_key"])["name"]
  priority            = each.value["priority"]
  action              = "Dnat"

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = tolist([lookup(azurerm_public_ip.this, each.value["firewall_key"])["ip_address"]])
      protocols             = rule.value.protocols
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }

  depends_on = [azurerm_firewall.this]
}

resource "azurerm_firewall_application_rule_collection" "this" {
  for_each            = var.fw_application_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = lookup(azurerm_firewall.this, each.value["firewall_key"])["name"]
  priority            = each.value["priority"]
  action              = each.value["action"]

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name             = rule.value.name
      description      = rule.value.description
      source_addresses = rule.value.source_addresses
      fqdn_tags        = lookup(rule.value, "target_fqdns", null) == null && lookup(rule.value, "fqdn_tags", null) != null ? rule.value.fqdn_tags : []
      target_fqdns     = lookup(rule.value, "fqdn_tags", null) == null && lookup(rule.value, "target_fqdns", null) != null ? rule.value.target_fqdns : []

      dynamic "protocol" {
        for_each = lookup(rule.value, "target_fqdns", null) != null && lookup(rule.value, "fqdn_tags", null) == null ? lookup(rule.value, "protocol", []) : []
        content {
          port = lookup(protocol.value, "port", null)
          type = protocol.value.type
        }
      }
    }
  }

  depends_on = [azurerm_firewall.this]
}
