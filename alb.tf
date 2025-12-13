########################################
# Application Load Balancer
########################################

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false

  subnets = [for s in aws_subnet.public : s.id]

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

########################################
# Target Group
########################################

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

########################################
# Listener
########################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
