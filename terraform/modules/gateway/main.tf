resource "aws_iam_policy" "products-lambda-agw" {
  name        = "APIGatewayPermissionsPolicy"
  description = "Permisos necesarios para gestionar API Gateway"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "apigateway:POST",
          "apigateway:GET",
          "apigateway:PUT",
          "apigateway:DELETE",
          "apigateway:PATCH",
          "apigateway:TagResource",
          "lambda:InvokeFunction"
        ],
        Resource : "*"
      },
      {
        Effect : "Allow"
        Action : "iam:PassRole"
        Resource = aws_iam_role.products-lambda-agw.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "products-lambda-agw" {
  name       = "AttachAPIGatewayPolicy"
  policy_arn = aws_iam_policy.products-lambda-agw.arn
  roles = [aws_iam_role.products-lambda-agw.name]
}

resource "aws_iam_role" "products-lambda-agw" {
  name = "APIGatewayExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "products-lambda-agw" {
  role       = aws_iam_role.products-lambda-agw.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

resource "aws_api_gateway_rest_api" "lambda-products" {
  name        = "lambda-products-agw"
  description = "API Gateway REST vinculada a Lambda"
}

# Crea el recurso raíz (ANY)
resource "aws_api_gateway_method" "lambda-products-root" {
  rest_api_id   = aws_api_gateway_rest_api.lambda-products.id
  resource_id   = aws_api_gateway_rest_api.lambda-products.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integra Lambda con el recurso raíz (ANY)
resource "aws_api_gateway_integration" "lambda-products" {
  rest_api_id             = aws_api_gateway_rest_api.lambda-products.id
  resource_id             = aws_api_gateway_rest_api.lambda-products.root_resource_id
  http_method             = aws_api_gateway_method.lambda-products-root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-west-3:lambda:path/2015-03-31/functions/${aws_lambda_function.products.arn}/invocations"
  credentials             = aws_iam_role.products-lambda-agw.arn
}

# Crea un recurso de ejemplo (/{proxy+})
resource "aws_api_gateway_resource" "lambda-products" {
  rest_api_id = aws_api_gateway_rest_api.lambda-products.id
  parent_id   = aws_api_gateway_rest_api.lambda-products.root_resource_id
  path_part   = "{proxy+}"
}

# Crea el método ANY para el recurso {proxy+}
resource "aws_api_gateway_method" "lambda-products" {
  rest_api_id   = aws_api_gateway_rest_api.lambda-products.id
  resource_id   = aws_api_gateway_resource.lambda-products.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integra Lambda con el recurso {proxy+}
resource "aws_api_gateway_integration" "lambda-products-resource" {
  rest_api_id             = aws_api_gateway_rest_api.lambda-products.id
  resource_id             = aws_api_gateway_resource.lambda-products.id
  http_method             = aws_api_gateway_method.lambda-products.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-west-3:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  credentials             = aws_iam_role.products-lambda-agw.arn
}

# Despliega el API Gateway
resource "aws_api_gateway_deployment" "lambda-products" {
  depends_on = [
    aws_api_gateway_integration.lambda-products-resource,
    aws_api_gateway_integration.lambda-products-resource
  ]
  rest_api_id = aws_api_gateway_rest_api.lambda-products.id
}

# Da permisos a API Gateway para invocar la Lambda
resource "aws_lambda_permission" "apigateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda-products.execution_arn}/*"
}