Kind           = "service-resolver"
Name           = "failover-dc1"
ConnectTimeout = "0s"
Failover = {
  "*" = {
    Datacenters = ["dc2"]
  }
}
