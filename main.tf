resource "panos_address_object" "ip_objects" {
  for_each    = { for k, v in local.ip_objects : replace("${k.app}-${k.netmask}", "/", "_") => k }
  name        = each.key
  value       = each.value.netmask
  type        = each.value.object_type
  description = ""
  tags = [
    "createdByTerraform",
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_address_object" "fqdn_objects" {
  for_each    = { for k, v in local.fqdn_objects : "${k.app}-${k.fqdn}" => k }
  name        = each.key
  value       = each.value.fqdn
  type        = each.value.object_type
  description = ""
  tags = [
    "createdByTerraform",
  ]
  lifecycle {
    create_before_destroy = true
  }
}


# resource "panos_custom_url_category" "custom_url_list" {
#   for_each    = { for k, v in local.url_categories : "${v.name}" => k }
#   name        = each.value.name
#   description = "Made by Terraform"
#   sites       = each.value.urls
#   type        = "URL List"
# }

resource "panos_panorama_service_object" "service_objects" {
  for_each         = { for k, v in local.services : "${v.app}-${v.protocol}_${v.destination_port}" => k }
  name             = each.key
  protocol         = each.value.protocol
  destination_port = each.value.destination_port
  tags = [
    "createdByTerraform",
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "panos_panorama_security_rule_group" "rules" {
  position_keyword = "bottom"
  rulebase         = "post-rulebase"
  device_group     = var.device-group
  dynamic "rule" {
    for_each = var.rules
    content {
      name                  = rule.key
      source_zones          = ["internal"]
      source_addresses      = try(coalescelist([for i in rule.value.source.ip-netmask : replace("${rule.value.app}-${i}", "/", "_")], [for x in rule.value.source.fqdn : "${rule.value.app}-${x}"]), ["any"])
      source_users          = ["any"]
      destination_zones     = ["internet"]
      destination_addresses = try(coalescelist([for i in rule.value.destination.ip-netmask : replace("${rule.value.app}-${i}", "/", "_")], [for x in rule.value.destination.fqdn : "${rule.value.app}-${x}"]), ["any"])
      applications          = ["any"]
      services              = ["application-default"]
      categories            = ["any"]
      # group                 = "Outbound"
      log_setting = "standard-log-profile"
      action      = "allow"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    resource.panos_panorama_service_object.service_objects,
    resource.panos_address_object.ip_objects,
    resource.panos_address_object.fqdn_objects
  ]
}