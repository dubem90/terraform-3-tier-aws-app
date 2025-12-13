########################################
# RDS Subnet Group
########################################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = [for s in aws_subnet.db : s.id]

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}

########################################
# RDS Instance
########################################

resource "aws_db_instance" "app_db" {
  identifier              = "${var.project_name}-db"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = 100

  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  username                = var.db_username
  password                = var.db_password

  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = false

  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  backup_retention_period = 7

  tags = {
    Name = "${var.project_name}-rds"
  }
}
