locals {
  public_log_config = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.log_group.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "public"
    }
  }
  public_api_name = "${var.name}-public-api"
  public_api_port = 8080
}

resource "aws_ecs_service" "public_api" {
  name            = local.public_api_name
  cluster         = var.ecs_cluster
  task_definition = module.public_api.task_definition_arn
  desired_count   = 1
  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_security_group]
  }
  launch_type            = "FARGATE"
  propagate_tags         = "TASK_DEFINITION"
  enable_execute_command = true
}

module "public_api" {
  source                   = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version                  = "0.2.0"
  requires_compatibilities = ["FARGATE"]
  family                   = local.public_api_name
  port                     = local.public_api_port
  log_configuration        = local.public_log_config
  container_definitions = [{
    name             = "public-api"
    image            = "hashicorpdemoapp/public-api:v0.0.5"
    essential        = true
    logConfiguration = local.public_log_config
    environment = [{
      name  = "NAME"
      value = local.public_api_name
      }, {
      name  = "BIND_ADDRESS"
      value = ":${local.public_api_port}"
      }, {
      name  = "PRODUCT_API_URI"
      value = "http://localhost:${local.product_api_port}"
    }]
    portMappings = [
      {
        containerPort = local.public_api_port
        hostPort      = local.public_api_port
        protocol      = "tcp"
      }
    ]
    cpu         = 0
    mountPoints = []
    volumesFrom = []
  }]
  upstreams = [
    {
      destination_name = local.product_api_name
      local_bind_port  = local.product_api_port
    }
  ]
  retry_join                     = [var.consul_attributes.consul_retry_join]
  tls                            = true
  consul_server_ca_cert_arn      = var.consul_attributes.consul_server_ca_cert_arn
  gossip_key_secret_arn          = var.consul_attributes.gossip_key_secret_arn
  acls                           = true
  consul_client_token_secret_arn = var.consul_attributes.consul_client_token_secret_arn
  acl_secret_name_prefix         = var.consul_attributes.acl_secret_name_prefix
}
