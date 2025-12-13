########################################
# Standalone Web EC2 Instance (Public)
########################################

resource "aws_instance" "web" {
  ami           = "ami-068c0051b15cdb816"   # Amazon Linux 2
  instance_type = "t2.micro"

  # FIXED: use the public subnet from the new VPC structure
  subnet_id = aws_subnet.public["us-east-1a"].id

  # FIXED: security group must be alb_sg or new web_sg
  vpc_security_group_ids = [
    aws_security_group.alb_sg.id
  ]

  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Standalone Web EC2 Working!</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "${var.project_name}-web-instance"
  }
}
