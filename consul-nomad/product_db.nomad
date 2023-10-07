job "product-api-db" {
  datacenters = ["dc1"]

  type = "service"

  group "product-db" {

    // consul {
    //   namespace = "hashicups"
    // }

    vault {
      namespace = ""
      policies = ["nomad-secret-policy"]
    }

    ephemeral_disk {
      migrate = true
      size    = 300
      sticky  = true
    }

    network {
      mode = "host"
      port "db" {
        static = 5432
        to = 5432
      }
    }

    service {
      name = "postgres-db"
      port = "db"
      tags = ["hashicups", "demo"]
    }
    
    task "postgres" {
      driver = "docker"

      config {
        // https://hub.docker.com/r/hashicorpdemoapp/frontend/tags
        image = "hashicorpdemoapp/product-api-db:v0.0.20"
        args = ["-c", "listen_addresses=*", "-c", "logging_collector=on", "-c", "log_directory=log", "-c", "log_filename=postgresql-%Y-%m-%d_%H%M%S.log", "-c", "log_connections=true"]
        ports = ["db"]
        network_mode = "host"
      }

      template {
  data = <<EOH
POSTGRES_DB=products
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
EOH

  destination = "secrets/file.env"
  env         = true
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
  }
}
