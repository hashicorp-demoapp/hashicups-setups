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
enable_central_service_config = true

auto_encrypt {
    tls = true
}

verify_incoming        = false
verify_outgoing        = true
verify_server_hostname = true

ca_file = "consul/config/certs/consul-agent-ca.pem"
cert_file = "consul/config/certs/dc1-client-consul-0.pem"
key_file  = "consul/config/certs/dc1-client-consul-0-key.pem"

acl {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  enable_token_replication = true
  down_policy = "extend-cache"

  tokens {
    default = "20d16fb2-9bd6-d238-bfdc-1fab80177667"
  }
}
