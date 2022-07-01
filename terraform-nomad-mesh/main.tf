terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = ">= 1.4.17"
    }
    consul = {
      source  = "hashicorp/consul"
      version = ">= 2.15.1"
    }
  }
}

provider "nomad" {
  address   = var.nomad_address
  secret_id = var.nomad_token
}

provider "consul" {
  address    = var.consul_address
  token      = var.consul_token
  datacenter = var.datacenter
}

# Proxy defaults
resource "consul_config_entry" "proxy-defaults" {
  name = "global"
  kind = "proxy-defaults"

  config_json = jsonencode({
    Config : {
      Protocol                   = "http",
      Envoy_prometheus_bind_addr = "0.0.0.0:9102"
    },
    TransparentProxy : {},
    MeshGateway : {
      Mode = "local"
    },
    Expose : {}
  })
}

# Service defaults
resource "consul_config_entry" "db-service-defaults" {
  name = "hashicups-db"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp",
    TransparentProxy : {},
    MeshGateway : {
      Mode = "local"
    },
    Expose : {}
  })
}

resource "consul_config_entry" "frontend-service-defaults" {
  name = "hashicups-frontend"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http",
    TransparentProxy : {},
    MeshGateway : {
      Mode = "local"
    },
    Expose : {}
  })
}

resource "consul_config_entry" "public-api-service-defaults" {
  name = "hashicups-public-api"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http",
    TransparentProxy : {},
    MeshGateway : {
      Mode = "local"
    },
    Expose : {}
  })
}

resource "consul_config_entry" "product-api-service-defaults" {
  name = "hashicups-product-api"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http",
    TransparentProxy : {},
    MeshGateway : {
      Mode = "local"
    },
    Expose : {}
  })
}

resource "consul_config_entry" "payment-api-service-defaults" {
  name = "hashicups-payment-api"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http",
    TransparentProxy : {},
    MeshGateway : {
      Mode = "local"
    },
    Expose : {}
  })
}

# Service routers
resource "consul_config_entry" "frontend-service-router" {
  name = "hashicups-frontend"
  kind = "service-router"

  config_json = jsonencode({
    Routes = [
      {
        Match = {
          HTTP = {
            PathPrefix = "/api"
          }
        }
        Destination = {
          Service = "hashicups-public-api"
        }
      }
      # NOTE: a default catch-all will send unmatched traffic to "frontend"
    ]
  })
}

# Intentions
resource "consul_config_entry" "frontend-intentions" {
  name = "hashicups-frontend"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "hashicups-ingress-gateway"
        Precedence = 9
        Type       = "consul"
      }
    ]
  })
}

resource "consul_config_entry" "public-api-intentions" {
  name = "hashicups-public-api"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "hashicups-ingress-gateway"
        Precedence = 9
        Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = "hashicups-frontend"
        Precedence = 9
        Type       = "consul"
      }
    ]
  })
}

resource "consul_config_entry" "payment-api-intentions" {
  name = "hashicups-payment-api"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "hashicups-public-api"
        Precedence = 9
        Type       = "consul"
      }
    ]
  })
}

resource "consul_config_entry" "product-api-intentions" {
  name = "hashicups-product-api"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "hashicups-public-api"
        Precedence = 9
        Type       = "consul"
      }
    ]
  })
}

resource "consul_config_entry" "db-intentions" {
  name = "hashicups-db"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "hashicups-product-api"
        Precedence = 9
        Type       = "consul"
      }
    ]
  })
}

resource "nomad_job" "hashicups" {
  jobspec = templatefile("${path.module}/hashicups.nomad.tftpl",
    {
      nomad_region           = var.nomad_region
      datacenter             = var.datacenter
      frontend_version       = var.frontend_version
      public_api_version     = var.public_api_version
      payments_version       = var.payments_version
      product_api_version    = var.product_api_version
      product_api_db_version = var.product_api_db_version
      postgres_db            = var.postgres_db
      postgres_user          = var.postgres_user
      postgres_password      = var.postgres_password
      product_api_port       = var.product_api_port
      frontend_port          = var.frontend_port
      payments_api_port      = var.payments_api_port
      public_api_port        = var.public_api_port
  })
}

resource "nomad_job" "ingress-gateway" {
  jobspec = templatefile("${path.module}/ingress-gateway.nomad.tftpl",
    {
      nomad_region = var.nomad_region
      datacenter   = var.datacenter
      frontend_url = var.frontend_url
  })
}
