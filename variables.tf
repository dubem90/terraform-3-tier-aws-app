########################################
# Global Settings
########################################

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "three-tier-app"
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "dev"
}

########################################
# VPC + Networking
########################################

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks for App Tier"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "db_subnets" {
  description = "Subnet CIDRs for RDS tier"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

########################################
# App Tier Settings (Launch Template)
########################################

variable "app_ami" {
  description = "AMI ID for application EC2 instances"
  type        = string
  default     = "ami-068c0051b15cdb816"
}

variable "app_instance_type" {
  description = "EC2 instance type for application tier"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum ASG instance count"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum ASG instance count"
  type        = number
  default     = 4
}

########################################
# RDS Settings
########################################

variable "db_engine" {
  description = "Database engine (mysql/postgres)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for DB in GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Master DB username"
  type        = string
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}

########################################
# Tags
########################################

variable "tags" {
  description = "Extra tags to apply to resources"
  type        = map(string)

  default = {
    ManagedBy = "Terraform"
  }
}
