Kind           = "service-resolver"
Name           = "product-db"
ConnectTimeout = "0s"
Failover = {
  "*" = {
    Datacenters = ["dc2", "dc1"]
  }
}