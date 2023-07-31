# IP address objects resource block
resource "panos_address_object" "ip_objects" {
  # Using for_each loop to iterate over the local ip_objects set
  for_each    = { for k, v in local.ip_objects : replace("${k.app}-${k.netmask}", "/", "_") => k }
  
  # Configuration of the IP objects
  name        = each.key
  value       = each.value.netmask
  type        = each.value.object_type
  description = ""

  # Adding metadata to the resource
  tags = [
    "createdByTerraform",
  ]

  # Ensuring the resource is created before it's destroyed in updates
  lifecycle {
    create_before_destroy = true
  }
}

# FQDN objects resource block
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

# Service objects resource block
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

# Security rule group resource block
resource "panos_panorama_security_rule_group" "prisma_rules" {
  position_keyword = "bottom"
  rulebase         = "post-rulebase"
  device_group     = var.device-group
  
  # Dynamically creating security rules based on the var.rules map
  dynamic "rule" {
    for_each = var.rules
    content {
      name                  = rule.key
      source_zones          = ["PA_Trust"]
      source_addresses      = try(coalescelist([for i in rule.value.source.ip-netmask : replace("${rule.value.app}-${i}", "/", "_")], [for x in rule.value.source.fqdn : "${rule.value.app}-${x}"]), ["any"])
      source_users          = ["any"]
      destination_zones     = ["PA_Untrust"]
      destination_addresses = try(coalescelist([for i in rule.value.destination.ip-netmask : replace("${rule.value.app}-${i}", "/", "_")], [for x in rule.value.destination.fqdn : "${rule.value.app}-${x}"]), ["any"])
      applications          = ["any"]
      services              = ["application-default"]
      categories            = ["any"]
      log_setting = "standard-log-profile"
      action      = "allow"
    }
  }

  # Ensuring the resource is created before it's destroyed in updates
  lifecycle {
    create_before_destroy = true
  }

  # Dependencies to ensure these resources are created before the security rule group
  depends_on = [
    panos_panorama_service_object.service_objects,
    panos_address_object.ip_objects,
    panos_address_object.fqdn_objects
  ]
}
