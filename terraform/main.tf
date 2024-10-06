terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "1.2.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

# Create a Database
resource "awscc_rds_db_instance" "products-test-database" {
  db_instance_identifier = "products-test-database"
  db_name                = "products"
  db_instance_class      = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "12.5"
  publicly_accessible    = true
  master_username        = var.db_username
  master_user_password   = var.db_password
  promotion_tier         = 0

}