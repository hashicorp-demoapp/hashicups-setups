job "product-api" {
  datacenters = ["dc1"]

  type = "service"

  group "gateway" {

    // consul {
    //   namespace = "hashicups"
    // }

    network {
      mode = "bridge"
      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "api-gateway"
      
      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        gateway {
          proxy {
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
            } 
          }
          terminating {
            service {
              name = "product-api"
            }
          }
        }
      }
    }
  }

  group "product-api" {

    // consul {
    //   namespace = "hashicups"
    // }

    vault {
      namespace = ""
      policies = ["nomad-secret-policy"]
    }

    network {
      mode = "host"
      port "api" {
        to = 9090
      }
      port "metric" {
        to = 9103
      }
    }

    service {
      name = "product-api"
      tags = ["hashicups", "demo"]

      port = "api"

      check {
        type  = "http"
        interval = "10s"
        timeout  = "2s"
        path = "/health"
        port  = "api"
      }
    }
    
    task "product-api" {
      driver = "docker"

      config {
        // https://hub.docker.com/r/hashicorpdemoapp/frontend/tags
        image = "hashicorpdemoapp/product-api:v0.0.20"
        ports = ["api"]
        mount {
          type = "bind"
          target = "/conf.json"
          source = "local/conf.json"
        }
      }

      resources {
        cpu    = 200
        memory = 512
      }

      env {
        CONFIG_FILE = "/conf.json"
      }

      template {
        data = <<EOH
{{- range service "postgres-db" }}
{
  "db_connection": "host={{ .Address }} port={{ .Port }} user=postgres password=postgres dbname=products sslmode=disable",
  "bind_address": ":{{ env "NOMAD_PORT_api" }}",
  "metrics_address": ":{{ env "NOMAD_PORT_metric" }}"
}
{{- end }}
      EOH
        destination   = "local/conf.json"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      logs {
        max_files     = 10
        max_file_size = 10
      }
    }

    scaling {
      enabled = true
      min = 1
      max = 3
    }
  }
}
