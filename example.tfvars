rules = {
  my_rule = {
    app = "my_app"
    source = {
      ip-netmask = ["192.168.1.0/24"]
      fqdn       = ["www.example.com"]
    }
    destination = {
      ip-netmask = ["10.0.0.0/16"]
      fqdn       = ["www.destination.com"]
      service    = ["tcp/443", "tcp/80"]
    }
  }
  another_rule = {
    app = "another_app"
    source = {
      ip-netmask = ["192.168.2.0/24"]
      fqdn       = ["www.anotherexample.com"]
    }
    destination = {
      ip-netmask = ["10.0.1.0/16"]
      fqdn       = ["www.anotherdestination.com"]
      service    = ["tcp/22"]
    }
  }
}

device-group = "shared"
