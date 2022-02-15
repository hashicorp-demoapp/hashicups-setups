locals {
  frontend_log_config = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.log_group.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "frontend"
    }
  }
  frontend_name = "${var.name}-frontend"
  frontend_port = 80
}

resource "aws_ecs_service" "frontend" {
  name            = local.frontend_name
  cluster         = var.ecs_cluster
  task_definition = module.frontend.task_definition_arn
  desired_count   = 1
  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_security_group]
  }
  launch_type    = "FARGATE"
  propagate_tags = "TASK_DEFINITION"
  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = local.frontend_port
  }
  enable_execute_command = true
}

module "frontend" {
  source                   = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version                  = "0.2.0"
  requires_compatibilities = ["FARGATE"]
  family                   = local.frontend_name
  port                     = local.frontend_port
  log_configuration        = local.frontend_log_config
  container_definitions = [{
    name             = "frontend"
    image            = "hashicorpdemoapp/frontend:v0.0.8"
    essential        = true
    logConfiguration = local.frontend_log_config
    environment = [{
      name  = "NAME"
      value = local.frontend_name
    }]
    portMappings = [
      {
        containerPort = local.frontend_port
        hostPort      = local.frontend_port
        protocol      = "tcp"
      }
    ]
    cpu         = 0
    mountPoints = []
    volumesFrom = []
  }]
  upstreams = [
    {
      destination_name = local.public_api_name
      local_bind_port  = local.public_api_port
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
