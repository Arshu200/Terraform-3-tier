resource "aws_lb" "app-alb" {
  name               = "application-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.Application-SG]
  subnets            = [var.publicSubnet1, var.publicSubnet2]
  tags = {
    Name = "application loadbalancer"
  }
}

resource "aws_lb_target_group" "app-tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn # Default action if no rules match
  }
}

# <------------attaching the private servers to target group -------------------->
resource "aws_lb_target_group_attachment" "ps-1" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = var.private-server1
}

resource "aws_lb_target_group_attachment" "ps-2" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = var.private-server2
}

# <------------------Outputs of the ALB--------------->
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app-alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.app-tg.arn
}
