resource "aws_cloudwatch_log_group" "ecs-cluster" {
  name = "${var.env_name}/var/logs/ecs"
  #retention_in_days = 1
  tags = {
    Environment = var.env_name
  }
}

resource "aws_cloudwatch_log_group" "container" {
  name = "${var.env_name}/var/logs/container"
  #retention_in_days = 1
  tags = {
    Environment = var.env_name
  }
}