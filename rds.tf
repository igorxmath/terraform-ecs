# resource "aws_db_subnet_group" "db-subnets" {
#   name       = "dbsubnet-${var.env_name}"
#   subnet_ids = module.vpc.private_subnets

#   tags = {
#     Name = var.env_name
#   }
# }

# resource "aws_db_instance" "db-server-instance" {
#   allocated_storage    = 10
#   db_name              = var.db_name
#   engine               = "mariadb"
#   engine_version       = "10.6"
#   instance_class       = "db.t3.micro"
#   username             = var.db_username
#   password             = var.db_password
#   parameter_group_name = "default.mariadb10.6"
#   skip_final_snapshot  = true

#   db_subnet_group_name = aws_db_subnet_group.db-subnets.name
#   vpc_security_group_ids = [aws_security_group.allow_db.id]

#   tags = {
#     Name = var.env_name
#   }
# }