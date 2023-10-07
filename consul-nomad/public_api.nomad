job "public-api" {
  datacenters = ["dc1"]

  type = "service"

  group "public-api" {

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
      name = "public-api"
      tags = ["hashicups", "demo"]

      port = "api"
      
      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "product-api"
              local_bind_port  = 9090
            }
            upstreams {
              destination_name = "payments-api"
              local_bind_port  = 8888
            }
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
              envoy_tracing = true
            }
          }
        }
      }
    }
    
    task "public-api" {
      driver = "docker"

      config {
        // https://hub.docker.com/r/hashicorpdemoapp/frontend/tags
        image = "hashicorpdemoapp/public-api:v0.0.6"
        volumes = [
          "local:/etc/nginx/conf.d",
        ]
      }

      env {
        BIND_ADDRESS = ":${NOMAD_PORT_api}"
        PRODUCT_API_URI = "http://localhost:9090"
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
