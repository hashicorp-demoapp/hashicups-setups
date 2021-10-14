datacenter = "dc1"
data_dir =  "/opt/consul"
log_level = "INFO"
node_name = "payments0"
retry_join = [
    "consul_server_0",
    "consul_server_1",
    "consul_server_2"
    ]

enable_local_script_checks = true
ports {
  grpc = 8502
}