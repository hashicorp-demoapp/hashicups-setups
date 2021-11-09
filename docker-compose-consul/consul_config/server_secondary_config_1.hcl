data_dir = "/tmp/"
log_level = "DEBUG"
node_name = "consul_secondary_server_1"
datacenter = "dc2"
primary_datacenter = "dc1"

server = true

retry_join_wan = [
  "consul_server_0:",
  "consul_server_1:",
  "consul_server_2"
]

retry_join = [
 "consul_secondary_server_0",
 "consul_secondary_server_2"
]
encrypt = "Pckc6EF8EUt19xrIaavtcRItHzJ3ZD2ZWtaNThc8FOs="
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

auto_encrypt {
    allow_tls = true
}

verify_incoming        = false
verify_outgoing        = true
verify_server_hostname = true
verify_incoming_rpc    = true


enable_central_service_config = true
advertise_addr = "10.5.1.3"

ca_file = "/consul/config/certs/consul-agent-ca.pem",
cert_file = "/consul/config/certs/dc2-server-consul-1.pem",
key_file = "/consul/config/certs/dc2-server-consul-1-key.pem"