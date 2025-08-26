job "nginx" {
  datacenters = ["dc1"]

  group "nginx" {

    // consul {
    //   namespace = "hashicups"
    // }

    count = 1

    network {
      port "http" {}
    }

    service {
      name = "nginx"
      port = "http"
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"
        ports = ["http"]
        volumes = [
          "local:/etc/nginx/conf.d",
        ]
      }

      artifact {
        source = "https://img.icons8.com/color/2x/nginx.png"
        destination = "local/upload"
      }

      // env {
      //   CONSUL_NAMESPACE = "hashicups"
      // }

      template {
        data = <<EOF
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=STATIC:10m inactive=7d use_temp_path=off;

upstream frontend {
{{- range service "frontend" }}
  server {{ .Address }}:{{ .Port }};
{{- else }}# server 127.0.0.1:65535; # force a 502
{{- end }}
}

upstream api {
{{- range service "public-api" }}
  server {{ .Address }}:{{ .Port }};
{{- else }}# server 127.0.0.1:65535; # force a 502
{{- end }}
}

server {
  listen {{ env "NOMAD_PORT_http" }};

  location / {
    proxy_pass http://frontend;
  }
  location /api {
    proxy_pass http://api;
  }
  location /status {
    stub_status on;
  }
  location /_next/static {
    proxy_cache STATIC;
    proxy_pass http://frontend;
    # For testing cache - remove before deploying to production
    add_header X-Cache-Status $upstream_cache_status;
  }
  location /static {
    proxy_cache STATIC;
    proxy_ignore_headers Cache-Control;
    proxy_cache_valid 60m;
    proxy_pass http://frontend;
    # For testing cache - remove before deploying to production
    add_header X-Cache-Status $upstream_cache_status;
  }

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
}
EOF

        destination   = "local/load-balancer.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
    }
  }
}