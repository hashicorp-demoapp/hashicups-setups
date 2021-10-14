data_dir = "/tmp/"
log_level = "DEBUG"
node_name = "consul_server_1"
datacenter = "dc1"

server = true

retry_join = [
  "consul_server_0",
  "consul_server_2"
]
bootstrap_expect = 3
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

enable_central_service_config = true
