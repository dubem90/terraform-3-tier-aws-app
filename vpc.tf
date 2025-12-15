########################################
# VPC
########################################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

########################################
# Public Subnets
########################################

resource "aws_subnet" "public" {
  for_each = {
    "us-east-1a" = var.public_subnets[0]
    "us-east-1b" = var.public_subnets[1]
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${each.key}"
    Tier = "public"
  }
}

########################################
# Private App Subnets
########################################

resource "aws_subnet" "private" {
  for_each = {
    "us-east-1a" = var.private_subnets[0]
    "us-east-1b" = var.private_subnets[1]
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-${each.key}"
    Tier = "private-app"
  }
}

########################################
# Private DB Subnets
########################################

resource "aws_subnet" "db" {
  for_each = {
    "us-east-1a" = var.db_subnets[0]
    "us-east-1b" = var.db_subnets[1]
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.project_name}-db-${each.key}"
    Tier = "private-db"
  }
}

########################################
# NAT Gateway
########################################

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public["us-east-1a"].id
  tags          = { Name = "${var.project_name}-natgw" }
}


########################################
# Public Route Table
########################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

########################################
# Private Route Table (App - with NAT)
########################################
resource "aws_route_table" "private_app_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = { Name = "${var.project_name}-private-app-rt" }
}

resource "aws_route_table_association" "private_app_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app_rt.id
}

########################################
# Private Route Table (DB - no internet)
########################################
resource "aws_route_table" "private_db_rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-private-db-rt" }
}

resource "aws_route_table_association" "private_db_assoc" {
  for_each       = aws_subnet.db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db_rt.id
}
