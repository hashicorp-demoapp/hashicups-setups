datacenter = "dc1"
data_dir =  "/opt/consul"
log_level = "INFO"
node_name = "frontend-0"
retry_join = [
    "consul_server_0",
    "consul_server_1",
    "consul_server_2"
    ]
encrypt = "Pckc6EF8EUt19xrIaavtcRItHzJ3ZD2ZWtaNThc8FOs="
enable_local_script_checks = true
enable_central_service_config = true
ports {
  grpc = 8502
}