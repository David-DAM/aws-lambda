provider "aws" {
  region = "eu-west-3"
}

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

resource "aws_s3_bucket" "products" {
  bucket        = "products-images-test"
  force_destroy = true

  tags = {
    Name        = "Products"
    Environment = "Test"
  }
}

resource "aws_s3_bucket" "products-lambda" {
  bucket        = "products-lambda-code"
  force_destroy = true

  tags = {
    Name        = "Products"
    Environment = "Test"
  }
}

resource "aws_s3_object" "products-lambda-code" {
  bucket = aws_s3_bucket.products-lambda.id

  key    = "products-lamba-code.zip"
  source = "../target/aws-lambda-1.0-SNAPSHOT-lambda-package.zip"

  etag = filemd5("../target/aws-lambda-1.0-SNAPSHOT-lambda-package.zip")
}

resource "aws_iam_role" "products-lambda" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2024-10-13"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "products-lambda" {
  role       = aws_iam_role.products-lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "products" {
  function_name = "products-crud"

  s3_bucket = aws_s3_bucket.products-lambda.id
  s3_key    = aws_s3_object.products-lambda-code.key

  runtime = "java17"
  handler = "com.david.StreamLambdaHandler::handleRequest"

  source_code_hash = aws_s3_object.products-lambda-code.key

  role = aws_iam_role.products-lambda.arn
}
