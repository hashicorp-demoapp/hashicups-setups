job "frontend" {
  datacenters = ["dc1"]

  type = "service"

  group "frontend" {
    count = 1

    scaling {
      enabled = true
      min = 1
      max = 3
    }

    consul {
      namespace = "hashicups"
    }

    update {
      max_parallel     = 1
      min_healthy_time = "30s"
      healthy_deadline = "1m"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "frontend"
      tags = ["hashicups", "demo"]

      port = "http"

      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "public-api"
              local_bind_port  = 8080
            }
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
            }
          }
        }
      }
    }
    
    task "frontend" {
      driver = "docker"

      config {
        // https://hub.docker.com/r/hashicorpdemoapp/frontend/tags
        image = "hashicorpdemoapp/frontend:v1.0.3"
        ports = ["http"]
        volumes = [
          "local:/etc/nginx/conf.d",
        ]
      }

      template {
data = <<EOH
{{- range service "nginx" }}
NEXT_PUBLIC_PUBLIC_API_URL="http://{{ .Address }}:{{ .Port }}"
{{- end }}
EOH

  destination = "local/file.env"
  env         = true
      }

      env {
        // NEXT_PUBLIC_PUBLIC_API_URL = "/"
        PORT = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 200
        memory = 512
      }

      template {
        data = <<EOH
# /etc/nginx/conf.d/default.conf
server {
  listen       {{ env "NOMAD_PORT_http" }};
  server_name  {{ env "NOMAD_IP_http" }};
  #charset koi8-r;
  #access_log  /var/log/nginx/host.access.log  main;
  location / {
      root   /usr/share/nginx/html;
      index  index.html index.htm;
  }
  # Proxy pass the api location to save CORS
  # Use location exposed by Consul connect
  location /api {
      proxy_pass http://127.0.0.1:{{ env "NOMAD_UPSTREAM_PORT_public_api" }};
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "Upgrade";
      proxy_set_header Host $host;
  }
  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
      root   /usr/share/nginx/html;
  }
}
      EOH
        destination   = "local/default.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      logs {
        max_files     = 10
        max_file_size = 10
      }
    }
  }
}
