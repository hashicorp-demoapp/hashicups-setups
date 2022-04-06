resource "consul_config_entry" "product-api" {
  name = "product-api"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}