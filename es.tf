# resource "aws_security_group" "es" {
#   name        = "elasticsearch-${var.env_name}"
#   description = "Allows inbound access from ECS only"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port = 443
#     to_port   = 443
#     protocol  = "tcp"
#     security_groups  =  [aws_security_group.allow_private.id]
#   }

#   tags = {
#     Name = "allow_es"
#     Environment = var.env_name
#   }
# }

# data "aws_region" "current" {}

# data "aws_caller_identity" "current" {}

# resource "aws_elasticsearch_domain" "es" {
#   domain_name           = "esdomain"
#   elasticsearch_version = "7.4"

#   cluster_config {
#     instance_count         = 3
#     instance_type          = "m4.large.elasticsearch"
#     zone_awareness_enabled = true
#     zone_awareness_config {
#         availability_zone_count  = 3 
#     }
#   }

#   vpc_options {
#     subnet_ids = module.vpc.private_subnets

#     security_group_ids = [aws_security_group.es.id]
#   }

#   encrypt_at_rest {
#     enabled = true
#   }

#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }

#   advanced_options = {
#     "rest.action.multi.allow_explicit_index" = "true",
#     override_main_response_version           = false
#   }

#   access_policies = <<CONFIG
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowES",
#             "Action": "es:*",
#             "Principal": "*",
#             "Effect": "Allow",
#             "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/esdomain/*"
#         }
#     ]
# }
# CONFIG

#   tags = {
#     Environment    = var.env_name
#   }

#   depends_on = [aws_iam_service_linked_role.es]

#   lifecycle {
#     ignore_changes = [
#       tags,
#       tags_all
#     ]
#   }
# }
# resource "aws_iam_service_linked_role" "es" {
#   aws_service_name = "es.amazonaws.com"
# }