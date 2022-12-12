resource "aws_acm_certificate" "default" {
  private_key      = file(".certs/private.key")
  certificate_body = file(".certs/public.pub")
}

resource "aws_lb" "lb-app" {
  name               = "lb-${var.env_name}"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = module.vpc.public_subnets
  internal = false

  tags = {
    Environment = var.env_name
  }
}

resource "aws_lb_listener" "lb-listener-http" {
  load_balancer_arn = aws_lb.lb-app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}

resource "aws_lb_listener" "lb-listener-https" {
  load_balancer_arn = aws_lb.lb-app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = aws_acm_certificate.default.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.lb-listener-http.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "lb-tg" {
  name     = "lb-tg-${var.env_name}"
  port     = 5000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id
}

