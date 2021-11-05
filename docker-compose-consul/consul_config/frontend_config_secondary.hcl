datacenter = "dc2"
data_dir =  "/opt/consul"
log_level = "INFO"
node_name = "frontend-secondary"
retry_join = [
    "consul_secondary_server_0",
    "consul_secondary_server_1",
    "consul_secondary_server_2"
    ]
enable_local_script_checks = true
encrypt = "Pckc6EF8EUt19xrIaavtcRItHzJ3ZD2ZWtaNThc8FOs="
ports {
  grpc = 8502
}