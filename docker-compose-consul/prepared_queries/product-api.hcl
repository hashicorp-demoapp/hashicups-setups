Kind           = "service-resolver"
Name           = "product-api"
ConnectTimeout = "0s"
Failover = {
  "*" = {
    Datacenters = ["dc2", "dc1"]
  }
}