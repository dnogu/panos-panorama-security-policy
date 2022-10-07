locals {

  ip_objects = toset(flatten([
    for rule, rule_value in var.rules : [
      for key, values in rule_value : [
        for type, source in values : [
          for entry in source : {
            app         = rule_value.app
            object_type = type
            netmask     = entry
          }
        ] if contains(["ip-netmask"], type)
      ] if contains(["source", "destination"], key)
    ]
  ]))

  fqdn_objects = toset(flatten([
    for rule, rule_value in var.rules : [
      for key, values in rule_value : [
        for type, source in values : [
          for entry in source : {
            app         = rule_value.app
            object_type = type
            fqdn        = entry
          }
        ] if contains(["fqdn"], type)
      ] if contains(["source", "destination"], key)
    ]
  ]))

  services = toset(flatten([
    for rule, rule_value in var.rules : [
      for key, values in rule_value : [
        for type, source in values : [
          for entry in source : {
            app              = rule_value.app
            protocol         = element(split("/", entry), 0)
            destination_port = element(split("/", entry), 1)
          }
        ] if contains(["service"], type)
      ] if contains(["destination"], key)
    ]
  ]))

}
