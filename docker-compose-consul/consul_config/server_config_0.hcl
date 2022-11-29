data_dir = "/tmp/"
log_level = "DEBUG"
node_name = "consul_server_0"
datacenter = "dc1"
primary_datacenter = "dc1"

server = true

retry_join = [
  "consul_server_1:",
  "consul_server_2"
]

retry_join_wan = [
  "consul_secondary_server_0"
]

encrypt="Pckc6EF8EUt19xrIaavtcRItHzJ3ZD2ZWtaNThc8FOs="

bootstrap_expect = 3

ui_config {
 enabled = true
} 

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc_tls = 8502
}

connect {
  enabled = true
}

auto_encrypt {
    allow_tls = true
}

verify_incoming        = true
verify_outgoing        = true
verify_server_hostname = true
verify_incoming_rpc    = true

enable_central_service_config = true
advertise_addr = "10.5.0.2"

ca_file = "/consul/config/certs/consul-agent-ca.pem",
cert_file = "/consul/config/certs/dc1-server-consul-0.pem",
key_file = "/consul/config/certs/dc1-server-consul-0-key.pem"

performance {
  raft_multiplier = 2
}


acl {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  enable_token_replication = true
  down_policy = "extend-cache"

  tokens {
    initial_management = "20d16fb2-9bd6-d238-bfdc-1fab80177667"
  }
}
