# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

# resource "aws_vpc" "products" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"
#
#   tags = {
#     Name = "main"
#   }
# }
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13"

  name                 = "products-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "products" {
  name       = "products-db-subnet"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Products"
  }
}

resource "aws_db_parameter_group" "products" {
  name   = "products"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_security_group" "products" {
  name   = "products-rds-security"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Products"
  }
}

# Create a Database
resource "aws_db_instance" "products" {
  identifier           = "products-test-database"
  db_name              = "products"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.4"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.products.name
  vpc_security_group_ids = [aws_security_group.products.id]
  parameter_group_name = aws_db_parameter_group.products.name
  publicly_accessible  = true
  skip_final_snapshot  = true
}