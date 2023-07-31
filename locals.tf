locals {

  # Preparing IP address objects from rules
  ip_objects = toset(flatten([
    for rule, rule_value in var.rules : [
      for key, values in rule_value : [
        for type, source in values : [
          for entry in source : {
            app         = rule_value.app
            object_type = type
            netmask     = entry
          }
        ] if type == "ip-netmask"
      ] if key == "source" || key == "destination"
    ]
  ]))

  # Preparing FQDN objects from rules
  fqdn_objects = toset(flatten([
    for rule, rule_value in var.rules : [
      for key, values in rule_value : [
        for type, source in values : [
          for entry in source : {
            app         = rule_value.app
            object_type = type
            fqdn        = entry
          }
        ] if type == "fqdn"
      ] if key == "source" || key == "destination"
    ]
  ]))

  # Preparing Service objects from rules
  services = toset(flatten([
    for rule, rule_value in var.rules : [
      for key, values in rule_value : [
        for type, source in values : [
          for entry in source : {
            app              = rule_value.app
            protocol         = split("/", entry)[0]
            destination_port = split("/", entry)[1]
          }
        ] if type == "service"
      ] if key == "destination"
    ]
  ]))
}
