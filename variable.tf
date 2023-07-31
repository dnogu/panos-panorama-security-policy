variable "rules" {
  description = "Rules To Be Applied for Application"
  type = map(object({
    app = string
    source = object({
      ip-netmask = list(string)
      fqdn       = list(string)
    })
    destination = object({
      ip-netmask = list(string)
      fqdn       = list(string)
      service    = list(string)
    })
  }))
  nullable = false
}

variable "device-group" {
  description = "Device Group in Palo Alto for rules to be applied"
  type = string
}
