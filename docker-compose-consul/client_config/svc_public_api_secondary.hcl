service {
  name = "public-api"
  id = "public-api-secondary"
  port = 8080
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "payments"
            local_bind_port  = 1800
          }, 
          {
            destination_name = "product-api"
            local_bind_port  = 9090
          }
        ]
      }
    }
  }
   check {
     id =  "Public_API_Check",
     name = "public-api status check",
     service_id = "public-api-secondary",
     tcp  = "localhost:8080",
     interval = "1s",
     timeout = "1s"
   }
}