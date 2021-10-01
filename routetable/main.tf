data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.rt_additional_tags, data.azurerm_resource_group.this.tags)

}

# -
# - Route Table
# -
resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = each.value["name"]
  location                      = data.azurerm_resource_group.this.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = merge(local.tags, each.value.tags)
}

locals {
  subnet_route_table_associations_list = flatten([
    for k, v in var.route_tables : [
      for subnet_name in coalesce(v.subnet_names, []) : {
        key         = format("%s_%s", k, subnet_name)
        rt_key      = k
        subnet_name = subnet_name
      } if(subnet_name != null)
    ]
  ])
  subnet_route_table_associations = {
    for r in local.subnet_route_table_associations_list : r.key => r
  }
}

# Associates a Route Table with a Subnet within a Virtual Network
resource "azurerm_subnet_route_table_association" "this" {
  for_each       = local.subnet_route_table_associations
  route_table_id = azurerm_route_table.this[each.value.rt_key]["id"]
  subnet_id      = each.value.subnet_name #[each.value.subnet_id]
  #lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name)
}
