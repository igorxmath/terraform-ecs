resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic-${var.env_name}"
  description = "Allow web inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.ipv4_cloudflare
    ipv6_cidr_blocks = var.ipv6_cloudflare
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.ipv4_cloudflare
    ipv6_cidr_blocks = var.ipv6_cloudflare
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
    Environment = var.env_name
  }
}

resource "aws_security_group" "allow_private" {
  name        = "allow_private_traffic-${var.env_name}"
  description = "Allow private inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow private traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  =  [aws_security_group.allow_web.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_private"
    Environment = var.env_name
  }
}

# resource "aws_security_group" "allow_db" {
#   name        = "allow_db_traffic-${var.env_name}"
#   description = "Allows inbound access from ECS only"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description      = "MySQL"
#     from_port        = 3306
#     to_port          = 3306
#     protocol         = "tcp"
#     security_groups  =  [aws_security_group.allow_private.id]
#   }

#   tags = {
#     Name = "allow_db"
#     Environment = var.env_name
#   }
# }