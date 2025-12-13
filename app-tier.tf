########################################
# Launch Template for ASG
########################################

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = var.app_ami
  instance_type = var.app_instance_type

  # Correct security group reference
  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Hello from App Tier EC2!" > /var/www/html/index.html
EOF
  )

  tags = {
    Name = "${var.project_name}-launch-template"
  }
}

########################################
# Auto Scaling Group
########################################

resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-asg"

  # Private subnets (fixed)
  vpc_zone_identifier = [for s in aws_subnet.private : s.id]

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Link ASG to ALB target group
  target_group_arns = [
    aws_lb_target_group.app_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }
}
