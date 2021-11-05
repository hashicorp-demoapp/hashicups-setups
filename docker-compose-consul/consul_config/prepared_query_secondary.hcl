Kind           = "service-resolver"
Name           = "failover-dc2"
ConnectTimeout = "0s"
Failover = {
  "*" = {
    Datacenters = ["dc1"]
  }
}
