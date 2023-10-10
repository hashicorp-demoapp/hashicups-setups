variable "frontend_port" {
  type        = number
  default     = 3000
}
variable "nginx_port" {
  type        = number
  default     = 80
}
variable "public_api_port" {
  type        = number
  default     = 7070
}

variable "payment_api_port" {
  type        = number
  default     = 8080
}

variable "product_api_port" {
  type        = number
  default     = 9090
}

variable "product_db_port" {
  type        = number
  default     = 5432
}

job "hashicups" {
  datacenters = ["dc1"]
  group "nginx" {
    network {
      mode = "bridge"

      port "nginx" {
        static = var.nginx_port
      }
    }

    service {
      name = "nginx"
      port = "nginx"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "frontend"
              local_bind_port  = var.frontend_port
            }
            upstreams {
              destination_name = "public-api"
              local_bind_port  = var.public_api_port
            }
          }
        }
      }
    }
    task "nginx" {
        driver = "docker"
        meta {
          service = "nginx-reverse-proxy"
        }
        config {
          image = "nginx:alpine"
          ports = ["nginx"]
          mount {
            type   = "bind"
            source = "local/default.conf"
            target = "/etc/nginx/conf.d/default.conf"
          }
        }
        template {
          data =  <<EOF
            proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=STATIC:10m inactive=7d use_temp_path=off;
            upstream frontend_upstream {
              server {{ env "NOMAD_UPSTREAM_ADDR_frontend" }};
            }
            upstream public_api_upstream {
              server {{ env "NOMAD_UPSTREAM_ADDR_public_api" }};
            }
            server {
              listen {{ env "NOMAD_PORT_nginx" }};
              server_name {{ env "NOMAD_IP_nginx" }};
              server_tokens off;
              gzip on;
              gzip_proxied any;
              gzip_comp_level 4;
              gzip_types text/css application/javascript image/svg+xml;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection 'upgrade';
              proxy_set_header Host $host;
              proxy_cache_bypass $http_upgrade;
              location /_next/static {
                proxy_cache STATIC;
                proxy_pass http://frontend_upstream;
                # For testing cache - remove before deploying to production
                add_header X-Cache-Status $upstream_cache_status;
              }
              location /static {
                proxy_cache STATIC;
                proxy_ignore_headers Cache-Control;
                proxy_cache_valid 60m;
                proxy_pass http://frontend_upstream;
                # For testing cache - remove before deploying to production
                add_header X-Cache-Status $upstream_cache_status;
              }
              location / {
                proxy_pass http://frontend_upstream;
              }
            location /api {
              proxy_pass http://public_api_upstream;
            }
          }
          EOF
          destination = "local/default.conf"
      }
    }
  }
  group "frontend" {
    network {
      mode = "bridge"

      port "http" {
        static = var.frontend_port
      }
    }

    service {
      name = "frontend"
      port = "http"
      connect {
        sidecar_service {
        }
      }
    }
    
    task "frontend" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/frontend:v1.0.2"
        ports = ["http"]
      }

      env {
        NEXT_PUBLIC_PUBLIC_API_URL = "/"
      }
    }
  }

  group "public-api" {
    network {
      mode = "bridge"

      port "http" {
        static = var.public_api_port
      }
    }

    service {
      name = "public-api"
      port = "http"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "product-api"
              local_bind_port  = var.product_api_port
            }
            upstreams {
              destination_name = "payment-api"
              local_bind_port  = var.payment_api_port
            }
          }
        }
      }
    }

    task "public-api" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/public-api:v0.0.6"
        ports = ["http"]
      }

      env {
        BIND_ADDRESS = ":${var.public_api_port}"
        PRODUCT_API_URI = "http://localhost:${var.product_api_port}"
        PAYMENT_API_URI = "http://localhost:${var.payment_api_port}"
      }
    }
  }

  group "payment-api" {
    network {
      mode = "bridge"

      port "http" {
        static = var.payment_api_port
      }
    }

    service {
      name = "payment-api"
      port = "http"

      connect {
        sidecar_service {}
      }
    }

    task "payment-api" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/payments:v0.0.16"
        ports = ["http"]
      }
    }
  }

  group "product-api" {
    network {
      mode = "bridge"

      port "http" {
        static = var.product_api_port
      }

      port "healthcheck" {
        to = -1
      }
    }

    service {
      name = "product-api"
      port = "http"

      check {
        type     = "http"
        path     = "/health"
        interval = "5s"
        timeout  = "2s"
        expose   = true
        port     = "healthcheck"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "product-db"
              local_bind_port  = var.product_db_port
            }
          }
        }
      }
    }

    task "product-api" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/product-api:v0.0.20"
      }

      env {
        DB_CONNECTION = "host=localhost port=${var.product_db_port} user=postgres password=password dbname=products sslmode=disable"
        BIND_ADDRESS  = "localhost:${var.product_api_port}"
      }
    }
  }

  group "product-db" {
    network {
      mode = "bridge"

      port "http" {
        static = var.product_db_port
      }
    }

    service {
      name = "product-db"
      port = "http"

      connect {
        sidecar_service {}
      }
    }

    task "db" {
      driver = "docker"

      config {
        image = "hashicorpdemoapp/product-api-db:v0.0.20"
        ports = ["http"]
      }

      env {
        POSTGRES_DB       = "products"
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "password"
      }
    }
  }
}