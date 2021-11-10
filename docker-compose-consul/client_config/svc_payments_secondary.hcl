service {
  name = "payments"
  id = "payments-secondary"
  port = 8080
 
  # Required in order to allow registration of a sidecar
  connect { 
    sidecar_service {
    }
  }
}

 check {
     id =  "Payment",
     name = "Payment status check",
     service_id = "payments",
     tcp  = "localhost:8080",
     interval = "1s",
     timeout = "1s"
}
