datacenter = "dc2"
data_dir =  "/opt/consul"
log_level = "INFO"
node_name = "product-api-secondary0"
retry_join = [
    "consul_secondary_server_0",
    "consul_secondary_server_1",
    "consul_secondary_server_2"
    ]
encrypt = "Pckc6EF8EUt19xrIaavtcRItHzJ3ZD2ZWtaNThc8FOs="
enable_local_script_checks = true
ports {
  grpc = 8502
}