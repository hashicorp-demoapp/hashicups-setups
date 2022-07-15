job "payments-api" {
  datacenters = ["dc1"]

  type = "service"

  group "payments-api" {

    // consul {
    //   namespace = "hashicups"
    // }

    network {
      mode = "bridge"
      port "api" {
        to = 8080
      }
      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "payments-api"
      tags = ["hashicups", "demo"]

      port = "api"

      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
            } 
          }
        }
      }
    }
    
    task "payments-api" {
      driver = "docker"

      config {
        // https://hub.docker.com/r/hashicorpdemoapp/frontend/tags
        image = "hashicorpdemoapp/payments:v0.0.12"
        ports = ["api"]
        mount {
          type   = "bind"
          source = "local/application.properties"
          target = "/application.properties"
        }
      }

      template {
        data = "server.port={{ env \"NOMAD_PORT_api\"}}"
        destination = "local/application.properties"
      }

      resources {
        cpu    = 200
        memory = 512
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
