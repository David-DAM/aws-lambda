resource "aws_db_subnet_group" "products" {
  name       = "products-db-subnet"
  subnet_ids = var.public_subnets

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
  vpc_id = var.vpc_id

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