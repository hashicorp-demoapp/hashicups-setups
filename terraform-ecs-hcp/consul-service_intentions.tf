locals {
  public_api_name  = "public-api"
  frontend_name    = "frontend"
  product_api_name = "product-api"
  postgres_name    = "postgres"
  payments_name    = "payments"
}

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


resource "consul_config_entry" "deny_all" {
  name = "*"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "deny"
        Name       = "*"
        Precedence = 9
        Type       = "consul"
        Namespace  = "default"
      }
    ]
  })
}

resource "consul_config_entry" "payments_intentions" {
  name = local.payments_name
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


resource "consul_config_entry" "postgres_intentions" {
  name = local.postgres_name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.product_api_name
        Precedence = 9
        Type       = "consul"
        Namespace  = "default"
      }
    ]
  })
}

