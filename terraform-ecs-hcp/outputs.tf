output "client_lb_address" {
  value = "http://${aws_lb.example_client_app.dns_name}:9090/ui"
}

output "consul_ui_address" {
  value = hcp_consul_cluster.example.consul_public_endpoint_url
}