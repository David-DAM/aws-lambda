provider "aws" {
  region = "eu-west-3"
}


# data "aws_availability_zones" "available" {}

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.13"
#
#   name                 = "products-vpc"
#   cidr                 = "10.0.0.0/16"
#   azs                  = data.aws_availability_zones.available.names
#   public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   enable_dns_hostnames = true
#   enable_dns_support   = true
# }
#
# resource "aws_db_subnet_group" "products" {
#   name       = "products-db-subnet"
#   subnet_ids = module.vpc.public_subnets
#
#   tags = {
#     Name = "Products"
#   }
# }
#
# resource "aws_db_parameter_group" "products" {
#   name   = "products"
#   family = "postgres16"
#
#   parameter {
#     name  = "log_connections"
#     value = "1"
#   }
# }
#
# resource "aws_security_group" "products" {
#   name   = "products-rds-security"
#   vpc_id = module.vpc.vpc_id
#
#   ingress {
#     from_port = 5432
#     to_port   = 5432
#     protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port = 5432
#     to_port   = 5432
#     protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "Products"
#   }
# }
#
# resource "aws_db_instance" "products" {
#   identifier           = "products-test-database"
#   db_name              = "products"
#   instance_class       = "db.t3.micro"
#   allocated_storage    = 20
#   engine               = "postgres"
#   engine_version       = "16.4"
#   username             = var.db_username
#   password             = var.db_password
#   db_subnet_group_name = aws_db_subnet_group.products.name
#   vpc_security_group_ids = [aws_security_group.products.id]
#   parameter_group_name = aws_db_parameter_group.products.name
#   publicly_accessible  = true
#   skip_final_snapshot  = true
# }
#
# resource "aws_s3_bucket" "products" {
#   bucket        = "products-images-test"
#   force_destroy = true
#
#   tags = {
#     Name        = "Products"
#     Environment = "Test"
#   }
# }

# resource "aws_s3_bucket" "products-lambda" {
#   bucket        = "products-lambda-code"
#   force_destroy = true
#
#   tags = {
#     Name        = "Products"
#     Environment = "Test"
#   }
# }
#
# resource "aws_s3_object" "products-lambda-code" {
#   bucket = aws_s3_bucket.products-lambda.id
#
#   key    = "products-lamba-code.zip"
#   source = "../target/aws-lambda-1.0-SNAPSHOT-lambda-package.zip"
#
#   etag = filemd5("../target/aws-lambda-1.0-SNAPSHOT-lambda-package.zip")
# }
#
# resource "aws_iam_policy" "products-lambda-permissions" {
#   name        = "TerraformLambdaPermissions"
#   description = "Policy to create lambda functions"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect : "Allow"
#         Action : [
#           "lambda:CreateFunction",
#           "lambda:TagResource",
#           "lambda:PublishVersion"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect : "Allow"
#         Action : "iam:PassRole"
#         Resource = aws_iam_role.products-lambda.arn
#       }
#     ]
#   })
# }
#
#
# resource "aws_iam_policy_attachment" "products-lambda-permissions" {
#   name       = "policy-lamba-permissions"
#   policy_arn = aws_iam_policy.products-lambda-permissions.arn
#   roles = [aws_iam_role.products-lambda.name]
# }
#
# resource "aws_iam_role" "products-lambda" {
#   name = "products-lambda"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
#
# }
#
# resource "aws_iam_role_policy_attachment" "products-lambda" {
#   role       = aws_iam_role.products-lambda.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
#
# resource "aws_lambda_function" "products" {
#   function_name = "products-crud"
#
#   s3_bucket = aws_s3_bucket.products-lambda.id
#   s3_key    = aws_s3_object.products-lambda-code.key
#
#   runtime = "java17"
#   handler = "com.david.StreamLambdaHandler::handleRequest"
#
#   source_code_hash = aws_s3_object.products-lambda-code.key
#
#   role = aws_iam_role.products-lambda.arn
# }
#
# resource "aws_iam_policy" "products-lambda-agw" {
#   name        = "APIGatewayPermissionsPolicy"
#   description = "Permisos necesarios para gestionar API Gateway"
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect : "Allow",
#         Action : [
#           "apigateway:POST",
#           "apigateway:GET",
#           "apigateway:PUT",
#           "apigateway:DELETE",
#           "apigateway:PATCH",
#           "apigateway:TagResource",
#           "lambda:InvokeFunction"
#         ],
#         Resource : "*"
#       },
#       {
#         Effect : "Allow"
#         Action : "iam:PassRole"
#         Resource = aws_iam_role.products-lambda-agw.arn
#       }
#     ]
#   })
# }
#
# resource "aws_iam_policy_attachment" "products-lambda-agw" {
#   name       = "AttachAPIGatewayPolicy"
#   policy_arn = aws_iam_policy.products-lambda-agw.arn
#   roles = [aws_iam_role.products-lambda-agw.name]
# }
#
# resource "aws_iam_role" "products-lambda-agw" {
#   name = "APIGatewayExecutionRole"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         "Sid" : "",
#         Effect = "Allow",
#         Principal = {
#           Service = "apigateway.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "products-lambda-agw" {
#   role       = aws_iam_role.products-lambda-agw.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
# }
#
# resource "aws_api_gateway_rest_api" "lambda-products" {
#   name        = "lambda-products-agw"
#   description = "API Gateway REST vinculada a Lambda"
# }
#
# # Crea el recurso raíz (ANY)
# resource "aws_api_gateway_method" "lambda-products-root" {
#   rest_api_id   = aws_api_gateway_rest_api.lambda-products.id
#   resource_id   = aws_api_gateway_rest_api.lambda-products.root_resource_id
#   http_method   = "ANY"
#   authorization = "NONE"
# }
#
# # Integra Lambda con el recurso raíz (ANY)
# resource "aws_api_gateway_integration" "lambda-products" {
#   rest_api_id             = aws_api_gateway_rest_api.lambda-products.id
#   resource_id             = aws_api_gateway_rest_api.lambda-products.root_resource_id
#   http_method             = aws_api_gateway_method.lambda-products-root.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:eu-west-3:lambda:path/2015-03-31/functions/${aws_lambda_function.products.arn}/invocations"
#   credentials             = aws_iam_role.products-lambda-agw.arn
# }
#
# # Crea un recurso de ejemplo (/{proxy+})
# resource "aws_api_gateway_resource" "lambda-products" {
#   rest_api_id = aws_api_gateway_rest_api.lambda-products.id
#   parent_id   = aws_api_gateway_rest_api.lambda-products.root_resource_id
#   path_part   = "{proxy+}"
# }
#
# # Crea el método ANY para el recurso {proxy+}
# resource "aws_api_gateway_method" "lambda-products" {
#   rest_api_id   = aws_api_gateway_rest_api.lambda-products.id
#   resource_id   = aws_api_gateway_resource.lambda-products.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }
#
# # Integra Lambda con el recurso {proxy+}
# resource "aws_api_gateway_integration" "lambda-products-resource" {
#   rest_api_id             = aws_api_gateway_rest_api.lambda-products.id
#   resource_id             = aws_api_gateway_resource.lambda-products.id
#   http_method             = aws_api_gateway_method.lambda-products.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:eu-west-3:lambda:path/2015-03-31/functions/${aws_lambda_function.products.arn}/invocations"
#   credentials             = aws_iam_role.products-lambda-agw.arn
# }
#
# # Despliega el API Gateway
# resource "aws_api_gateway_deployment" "lambda-products" {
#   depends_on = [
#     aws_api_gateway_integration.lambda-products-resource,
#     aws_api_gateway_integration.lambda-products-resource
#   ]
#   rest_api_id = aws_api_gateway_rest_api.lambda-products.id
# }
#
# # Da permisos a API Gateway para invocar la Lambda
# resource "aws_lambda_permission" "apigateway_invoke" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.products.arn
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.lambda-products.execution_arn}/*"
# }
