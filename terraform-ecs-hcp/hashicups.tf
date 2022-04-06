locals {
  task_names = [
    for t in var.hashicups_settings : t.name
  ]

  needs_target = [
    for c in var.hashicups_settings : c if c.name == "frontend" || c.name == "public-api"
  ]

  entities = [
    for n in local.needs_target : {
      container_name = n.name
      container_port = n.portMappings[0].containerPort
      target_group   = aws_lb_target_group.hashicups[n.name].arn
    }
  ]
}

module "acl_controller" {
  source  = "registry.terraform.io/hashicorp/consul-ecs/aws//modules/acl-controller"
  version = "0.4.0"
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = var.aws_logs_group #aws_cloudwatch_log_group.log_group.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "consul-acl-controller"
    }
  }
  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.bootstrap_token.arn
  consul_server_http_addr           = hcp_consul_cluster.example.consul_public_endpoint_url
  ecs_cluster_arn                   = aws_ecs_cluster.this.arn
  region                            = var.region
  subnets                           = module.vpc.private_subnets
  name_prefix                       = var.name
}

module "hashicups-tasks" {
  for_each = { for service in var.hashicups_settings : service.name => service }
  source   = "registry.terraform.io/hashicorp/consul-ecs/aws//modules/mesh-task"
  version  = "0.4.0"

  family = each.value.name
  port   = each.value.portMappings[0].hostPort #9090
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = "hashicups-ecs"
      awslogs-region        = "us-east-1"
      awslogs-stream-prefix = each.value.name
      awslogs-create-group  = "true"
    }
  }
  container_definitions = [{
    name      = each.value.name
    image     = each.value.image
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "hashicups-ecs-apps"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = each.value.name
        awslogs-create-group  = "true"
      }
    }
    # Create the environment variables so that the frontend is loaded with the environment variable needed to communicate with public-api
    environment = each.value.name == "frontend" ? concat(each.value.environment,
      [
        {
          name = "NEXT_PUBLIC_PUBLIC_API_URL",
          #value = "${hcp_consul_cluster.example.consul_public_endpoint_url}:8081"
          value = "http://${aws_lb.example_client_app.dns_name}:8081"
        },
        {
          name  = "NAME"
          value = "${var.name}-${each.value.name}"
        }
        # The else of the ternary begins here. Add the NAME key for the rest of the task definitions.
      ]) : concat(each.value.environment,
      [{
        name  = "NAME"
        value = "${var.name}-${each.value.name}"
    }])
    portMappings = [
      {
        containerPort = each.value.portMappings[0].containerPort
        hostPort      = each.value.portMappings[0].hostPort
        protocol      = each.value.portMappings[0].protocol
      }
    ]
    cpu         = 0
    mountPoints = []
    volumesFrom = []
  }]
  upstreams = length(each.value.upstreams) > 0 ? each.value.upstreams : []
  #  upstreams = [
  #    {
  #      destination_name = each.value#"${var.name}-example-server-app"
  #      local_bind_port  = 1234
  #    },
  #
  #  ]
  retry_join                     = jsondecode(base64decode(hcp_consul_cluster.example.consul_config_file))["retry_join"]
  tls                            = true
  consul_server_ca_cert_arn      = aws_secretsmanager_secret.consul_ca_cert.arn
  gossip_key_secret_arn          = aws_secretsmanager_secret.gossip_key.arn
  acls                           = true
  consul_client_token_secret_arn = module.acl_controller.client_token_secret_arn
  acl_secret_name_prefix         = var.name
  consul_datacenter              = var.hcp_datacenter_name
  consul_partition               = null
  consul_namespace               = null
  task_role = {
    id  = each.value.name
    arn = aws_iam_role.hashicups.arn
  }
  additional_execution_role_policies = [
    aws_iam_policy.hashicups.arn
  ]
}


# Next, map the ECS Task Definition's family name to the AWS ECS Service.
# mesh-task doesn't directly provide the family name as an output, we use the data resource to lookup the value.

data "aws_ecs_task_definition" "tasks" {
  for_each = toset(local.task_names)
  # each.value represents the readable name that the task_definition data resource uses to search for the task_definition.
  task_definition = each.value

  # There is no direct or indirect relationship to the mesh-task resource. We use the depends_on so
  # the data resource doesn't attempt to lookup task names that have yet been created.
  depends_on = [module.hashicups-tasks]
}

# this is where I moved entities

resource "aws_ecs_service" "service" {
  for_each        = data.aws_ecs_task_definition.tasks
  name            = each.value.family
  cluster         = aws_ecs_cluster.this.arn
  task_definition = each.value.arn
  desired_count   = 1
  network_configuration {
    # Only the frontend and public-api go into the public subnet with public IPs.
    subnets          = each.value.family == "frontend" || each.value.family == "public-api" ? module.vpc.public_subnets : module.vpc.private_subnets
    assign_public_ip = each.value.family == "frontend" || each.value.family == "public-api" ? true : false

  }
  launch_type    = "FARGATE"
  propagate_tags = "TASK_DEFINITION"
  dynamic "load_balancer" {
    # Only configure load balancing targets for tasks that require it, namely, any entity present in the local.entities list that filters the required tasks.
    # The for_each only runs when the container name and task definition match each other.
    for_each = { for e in local.entities : e.container_name => e if each.value.task_definition == e.container_name }

    content {
      container_name   = each.value.task_definition
      container_port   = load_balancer.value.container_port
      target_group_arn = load_balancer.value.target_group
    }
  }
  enable_execute_command = true
}