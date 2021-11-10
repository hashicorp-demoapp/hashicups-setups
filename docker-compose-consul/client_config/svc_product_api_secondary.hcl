service {
  name = "product-api"
  id = "product-api-secondary"
  port = 9090
 
  # Required in order to allow registration of a sidecar
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "product-db"
            local_bind_port  = 5432
          }
        ]
      }
    }
  }
   check {
     id =  "Product API",
     name = "Product API status check",
     service_id = "product-api",
     tcp  = "localhost:9090",
     interval = "1s",
     timeout = "3s"
  }
}
