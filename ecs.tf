module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"

  cluster_name = "cluster-${var.env_name}"

  cluster_settings = {
    "name": "containerInsights",
    "value": "enabled"
  }

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "${var.env_name}/var/logs/ecs"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {}
  }
}

resource "aws_ecs_task_definition" "task" {
  family                = "task-${var.env_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  #depends_on               = [aws_db_instance.db-server-instance]
  container_definitions = jsonencode(
    [
      {
        "name"      = "${var.app_name}-${var.env_name}"
        "image"     = "igormath/flask-conversor-app:latest"
        "cpu"       = 1024
        "memory"    = 2048
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 5000
            "hostPort"      = 5000
          }
        ]
        
        "logConfiguration" = {
            "logDriver" = "awslogs"
            "options" = {
              "awslogs-group" = "${var.env_name}/var/logs/container"
              "awslogs-region" = var.region
              "awslogs-stream-prefix" = var.app_name
          }
        }

      }
    ]
  )

  tags = {
    Environment = var.env_name
  }
}

resource "aws_ecs_service" "service" {
  name            = "service-${var.env_name}"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-tg.arn
    container_name   = "${var.app_name}-${var.env_name}"
    container_port   = 5000
  }

  network_configuration {
      subnets = module.vpc.private_subnets
      security_groups = [aws_security_group.allow_private.id]
  }

  capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight = 1
  }

  tags = {
    Environment = var.env_name
  }
}