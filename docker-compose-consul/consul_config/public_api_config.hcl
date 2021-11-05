datacenter = "dc1"
data_dir =  "/opt/consul"
log_level = "INFO"
node_name = "public-api-0"
retry_join = [
    "consul_server_0",
    "consul_server_1",
    "consul_server_2"
    ]

enable_local_script_checks = true
ports {
  grpc = 8502
}
encrypt="Pckc6EF8EUt19xrIaavtcRItHzJ3ZD2ZWtaNThc8FOs="
service {
  name = "public-api"
  id = "public-api"
  port = 8080
}
