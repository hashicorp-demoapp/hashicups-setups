variable "name" {
  description = "Name to be used on all the resources as identifier."
  type        = string
  default     = "consul-ecs-hashicups"
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "lb_ingress_ip" {
  description = "Your Public IP. This is used in the load balancer security groups to ensure only you can access the Consul UI and example application."
  type        = string
}

variable "hcp_datacenter_name" {
  type        = string
  description = "The name of datacenter the Consul cluster belongs to"
  default     = "dc1"
}

variable "default_tags" {
  description = "Default Tags for AWS"
  type        = map(string)
  default = {
    Environment = "dev"
    Team        = "Education-Consul"
    tutorial    = "Serverless Consul service mesh with ECS and HCP"
  }
}

variable "hashicups_settings" {
  default = [
    {
      name  = "frontend"
      image = "hashicorpdemoapp/frontend:v1.0.3"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "http"
        }
      ],
      upstreams = [
        {
          destinationName = "public-api"
          localBindPort   = 8081
        }
      ],
      environment = []
    },
    {
      name  = "payments"
      image = "hashicorpdemoapp/payments:v0.0.16"
      portMappings = [{
        protocol      = "http"
        containerPort = 8080
        hostPort      = 8080
      }]
      upstreams   = []
      environment = []
    },
    {
      name  = "postgres"
      image = "hashicorpdemoapp/product-api-db:v0.0.21"
      environment = [{
        name  = "POSTGRES_DB"
        value = "products"
        },
        {
          name  = "POSTGRES_USER"
          value = "postgres"
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = "password"
      }]
      portMappings = [{
        protocol      = "tcp"
        containerPort = 5432
        hostPort      = 5432
      }]
      upstreams = []
    },
    {
      name  = "product-api"
      image = "hashicorpdemoapp/product-api:v0.0.21"
      environment = [{
        #        name = "CONFIG_FILE",
        #        # Discrepancy in the repo: conf.json or config.json? Conf.json returns not found
        #        # Ref: https://github.com/hashicorp-demoapp/product-api-go/blob/main/docker_compose/docker-compose.yml#L8
        #        value = "./conf.json"
        ##      },
        #        {
        name  = "DB_CONNECTION"
        value = "host=localhost port=5432 user=postgres password=password dbname=products sslmode=disable"
        },
        {
          name  = "METRICS_ADDRESS"
          value = ":9103"
        },
        {
          name  = "BIND_ADDRESS"
          value = ":9090"
      }]
      portMappings = [{
        protocol      = "http"
        containerPort = 9090
        hostPort      = 9090
      }]
      upstreams = [
        {
          destinationName = "postgres"
          localBindPort   = 5432
        },

      ],
      volumes = []
    },
    {
      name  = "public-api"
      image = "hashicorpdemoapp/public-api:v0.0.7"
      environment = [{
        # ECS only suports container/host port equality. Since payments also uses 8080, switch this to 8081.
        # Ref: https://github.com/hashicorp-demoapp/public-api/blob/a576419df268b74966c4dfdb90d653f498026d6d/main.go#L30
        name = "BIND_ADDRESS"
        # We missed the colon here
        value = ":8081"
        },
        {
          name  = "PRODUCT_API_URI"
          value = "http://localhost:9090"
        },
        {
          name  = "PAYMENT_API_URI"
          value = "http://localhost:1800"
      }]
      portMappings = [{
        protocol      = "http"
        containerPort = 8081
        hostPort      = 8081
      }]
      upstreams = [{
        destinationName = "product-api"
        localBindPort   = 9090
      }]
    }
  ]
}

variable "aws_logs_group" {
  default = "hashicups"
}

variable "ecs_clusters" {
  default = [
    {
      name = "cluster-one"
    },
    {
      name = "cluster-two"
    }

  ]

}

variable "capacity_providers" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "hvn_settings" {
  default = {
    name = {
      main-hvn = "main-hvn"
    }
    cloud_provider = {
      aws = "aws"
    }
    region = {
      us-east-1 = "us-east-1"
    }
    cidr_block = "172.25.16.0/20"
  }
}


variable "target_group_settings" {
  default = {
    elb = {
      services = [
        {
          name                 = "frontend"
          service_type         = "http"
          protocol             = "HTTP"
          target_group_type    = "ip"
          port                 = "80"
          deregistration_delay = 30
          health = {
            healthy_threshold   = 2
            unhealthy_threshold = 2
            interval            = 30
            timeout             = 29
            path                = "/"
          }
        },
        {
          name                 = "public-api"
          service_type         = "http"
          protocol             = "HTTP"
          target_group_type    = "ip"
          port                 = "8081"
          deregistration_delay = 30
          health = {
            healthy_threshold   = 2
            unhealthy_threshold = 2
            interval            = 30
            timeout             = 29
            path                = "/"
            port                = "8081"
          },
        },
      ]
    }
  }
}

variable "cluster_cidrs" {
  type = any
  default = {
    ecs_cluster = {
      name       = "ecs_cluster_one"
      cidr_block = "10.0.0.0/16"
      private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    },
  }
}