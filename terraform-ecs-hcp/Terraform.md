## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >3.0.0 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | ~> 2.15.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >3.0.0 |
| <a name="provider_consul"></a> [consul](#provider\_consul) | ~> 2.15.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | ~> 0.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acl_controller"></a> [acl\_controller](#module\_acl\_controller) | registry.terraform.io/hashicorp/consul-ecs/aws//modules/acl-controller | 0.4.0 |
| <a name="module_hashicups-tasks"></a> [hashicups-tasks](#module\_hashicups-tasks) | registry.terraform.io/hashicorp/consul-ecs/aws//modules/mesh-task | 0.4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | registry.terraform.io/terraform-aws-modules/vpc/aws | 2.78.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_iam_policy.hashicups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.hashicups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.hashicups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.example_client_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.hashicups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.hashicups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route.private_to_hvn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_to_hvn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_secretsmanager_secret.bootstrap_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.consul_ca_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.gossip_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.bootstrap_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.consul_ca_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.gossip_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.example_client_app_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_from_client_alb_to_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_peering_connection_accepter.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [consul_config_entry.deny_all](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.payments_intentions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.postgres_intentions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.product-api](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.product_api_intentions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.public_api_intentions](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [hcp_aws_network_peering.default](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/aws_network_peering) | resource |
| [hcp_consul_cluster.example](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/consul_cluster) | resource |
| [hcp_hvn.server](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn) | resource |
| [hcp_hvn_route.peering_route](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn_route) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecs_task_definition.tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |
| [aws_security_group.vpc_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_logs_group"></a> [aws\_logs\_group](#input\_aws\_logs\_group) | n/a | `string` | `"hashicups"` | no |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | n/a | `list(string)` | <pre>[<br>  "FARGATE"<br>]</pre> | no |
| <a name="input_cluster_cidrs"></a> [cluster\_cidrs](#input\_cluster\_cidrs) | n/a | `any` | <pre>{<br>  "ecs_cluster": {<br>    "cidr_block": "10.0.0.0/16",<br>    "name": "ecs_cluster_one",<br>    "private_subnets": [<br>      "10.0.1.0/24",<br>      "10.0.2.0/24",<br>      "10.0.3.0/24"<br>    ],<br>    "public_subnets": [<br>      "10.0.4.0/24",<br>      "10.0.5.0/24",<br>      "10.0.6.0/24"<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags for AWS | `map(string)` | <pre>{<br>  "Environment": "dev",<br>  "Team": "Education-Consul",<br>  "tutorial": "Serverless Consul service mesh with ECS and HCP"<br>}</pre> | no |
| <a name="input_ecs_clusters"></a> [ecs\_clusters](#input\_ecs\_clusters) | n/a | `list` | <pre>[<br>  {<br>    "name": "cluster-one"<br>  },<br>  {<br>    "name": "cluster-two"<br>  }<br>]</pre> | no |
| <a name="input_hashicups_settings"></a> [hashicups\_settings](#input\_hashicups\_settings) | n/a | `list` | <pre>[<br>  {<br>    "environment": [],<br>    "image": "hashicorpdemoapp/frontend:v1.0.3",<br>    "name": "frontend",<br>    "portMappings": [<br>      {<br>        "containerPort": 3000,<br>        "hostPort": 3000,<br>        "protocol": "http"<br>      }<br>    ],<br>    "upstreams": [<br>      {<br>        "destinationName": "public-api",<br>        "localBindPort": 8081<br>      }<br>    ]<br>  },<br>  {<br>    "environment": [],<br>    "image": "hashicorpdemoapp/payments:v0.0.16",<br>    "name": "payments",<br>    "portMappings": [<br>      {<br>        "containerPort": 8080,<br>        "hostPort": 8080,<br>        "protocol": "http"<br>      }<br>    ],<br>    "upstreams": []<br>  },<br>  {<br>    "environment": [<br>      {<br>        "name": "POSTGRES_DB",<br>        "value": "products"<br>      },<br>      {<br>        "name": "POSTGRES_USER",<br>        "value": "postgres"<br>      },<br>      {<br>        "name": "POSTGRES_PASSWORD",<br>        "value": "password"<br>      }<br>    ],<br>    "image": "hashicorpdemoapp/product-api-db:v0.0.21",<br>    "name": "postgres",<br>    "portMappings": [<br>      {<br>        "containerPort": 5432,<br>        "hostPort": 5432,<br>        "protocol": "tcp"<br>      }<br>    ],<br>    "upstreams": []<br>  },<br>  {<br>    "environment": [<br>      {<br>        "name": "DB_CONNECTION",<br>        "value": "host=localhost port=5432 user=postgres password=password dbname=products sslmode=disable"<br>      },<br>      {<br>        "name": "METRICS_ADDRESS",<br>        "value": ":9103"<br>      },<br>      {<br>        "name": "BIND_ADDRESS",<br>        "value": ":9090"<br>      }<br>    ],<br>    "image": "hashicorpdemoapp/product-api:v0.0.21",<br>    "name": "product-api",<br>    "portMappings": [<br>      {<br>        "containerPort": 9090,<br>        "hostPort": 9090,<br>        "protocol": "http"<br>      }<br>    ],<br>    "upstreams": [<br>      {<br>        "destinationName": "postgres",<br>        "localBindPort": 5432<br>      }<br>    ],<br>    "volumes": []<br>  },<br>  {<br>    "environment": [<br>      {<br>        "name": "BIND_ADDRESS",<br>        "value": ":8081"<br>      },<br>      {<br>        "name": "PRODUCT_API_URI",<br>        "value": "http://localhost:9090"<br>      },<br>      {<br>        "name": "PAYMENT_API_URI",<br>        "value": "http://localhost:1800"<br>      }<br>    ],<br>    "image": "hashicorpdemoapp/public-api:v0.0.6",<br>    "name": "public-api",<br>    "portMappings": [<br>      {<br>        "containerPort": 8081,<br>        "hostPort": 8081,<br>        "protocol": "http"<br>      }<br>    ],<br>    "upstreams": [<br>      {<br>        "destinationName": "product-api",<br>        "localBindPort": 9090<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_hcp_datacenter_name"></a> [hcp\_datacenter\_name](#input\_hcp\_datacenter\_name) | The name of datacenter the Consul cluster belongs to | `string` | `"dc1"` | no |
| <a name="input_hvn_settings"></a> [hvn\_settings](#input\_hvn\_settings) | n/a | `map` | <pre>{<br>  "cidr_block": "172.25.16.0/20",<br>  "cloud_provider": {<br>    "aws": "aws"<br>  },<br>  "name": {<br>    "main-hvn": "main-hvn"<br>  },<br>  "region": {<br>    "us-east-1": "us-east-1"<br>  }<br>}</pre> | no |
| <a name="input_lb_ingress_ip"></a> [lb\_ingress\_ip](#input\_lb\_ingress\_ip) | Your Public IP. This is used in the load balancer security groups to ensure only you can access the Consul UI and example application. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier. | `string` | `"consul-ecs-hashicups"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"us-east-1"` | no |
| <a name="input_target_group_settings"></a> [target\_group\_settings](#input\_target\_group\_settings) | n/a | `map` | <pre>{<br>  "elb": {<br>    "services": [<br>      {<br>        "deregistration_delay": 30,<br>        "health": {<br>          "healthy_threshold": 2,<br>          "interval": 30,<br>          "path": "/",<br>          "timeout": 29,<br>          "unhealthy_threshold": 2<br>        },<br>        "name": "frontend",<br>        "port": "80",<br>        "protocol": "HTTP",<br>        "service_type": "http",<br>        "target_group_type": "ip"<br>      },<br>      {<br>        "deregistration_delay": 30,<br>        "health": {<br>          "healthy_threshold": 2,<br>          "interval": 30,<br>          "path": "/",<br>          "port": "8081",<br>          "timeout": 29,<br>          "unhealthy_threshold": 2<br>        },<br>        "name": "public-api",<br>        "port": "8081",<br>        "protocol": "HTTP",<br>        "service_type": "http",<br>        "target_group_type": "ip"<br>      }<br>    ]<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_lb_address"></a> [client\_lb\_address](#output\_client\_lb\_address) | n/a |
| <a name="output_consul_ui_address"></a> [consul\_ui\_address](#output\_consul\_ui\_address) | n/a |
