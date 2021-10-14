service {
  name = "frontend"
  id = "frontend"
  port = 80
 
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "public-api"
            local_bind_port  = 8080
          }
        ]
      }
    }
  }
   check {
     id =  "Frontend",
     name = "Frontend status check",
     service_id = "frontend",
     tcp  = "localhost:80",
     interval = "1s",
     timeout = "3s"
  }
}
