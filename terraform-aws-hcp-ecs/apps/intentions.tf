resource "consul_config_entry" "product_api_intentions" {
  name = local.product_api_name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.public_api_name
        Precedence = 9
        Type       = "consul"
        Namespace  = "default"
      }
    ]
  })
}

resource "consul_config_entry" "public_api_intentions" {
  name = local.public_api_name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.frontend_name
        Precedence = 9
        Type       = "consul"
        Namespace  = "default"
      }
    ]
  })
}
