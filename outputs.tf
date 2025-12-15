#############################################
# VPC & Networking Outputs
#############################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id] # FIXED for for_each
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id] # FIXED for for_each
}

output "db_subnet_ids" {
  description = "List of DB subnet IDs"
  value       = [for s in aws_subnet.db : s.id] # FIXED for for_each
}

#############################################
# Application Load Balancer Outputs
#############################################

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web_alb.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.web_alb.arn
}

output "alb_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_lb_target_group.app_tg.arn
}

#############################################
# App Tier Outputs (Launch Template & ASG)
#############################################

output "launch_template_id" {
  description = "ID of the EC2 Launch Template"
  value       = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "app_security_group_id" {
  description = "Security Group ID for App Tier"
  value       = aws_security_group.app_sg.id
}

#############################################
# RDS Outputs
#############################################

output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.app_db.address
}

output "rds_port" {
  description = "RDS port number"
  value       = aws_db_instance.app_db.port
}

output "rds_engine" {
  description = "Database engine used"
  value       = aws_db_instance.app_db.engine
}

output "rds_security_group_id" {
  description = "Security Group for RDS tier"
  value       = aws_security_group.rds_sg.id
}

#############################################
# Project Metadata Outputs
#############################################

output "project_name" {
  description = "Name of the project"
  value       = var.project_name
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}
