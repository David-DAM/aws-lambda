resource "aws_iam_policy" "products-lambda-permissions" {
  name        = "TerraformLambdaPermissions"
  description = "Policy to create lambda functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow"
        Action : [
          "lambda:CreateFunction",
          "lambda:TagResource",
          "lambda:PublishVersion"
        ]
        Resource = "*"
      },
      {
        Effect : "Allow"
        Action : "iam:PassRole"
        Resource = aws_iam_role.products-lambda.arn
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "products-lambda-permissions" {
  name       = "policy-lamba-permissions"
  policy_arn = aws_iam_policy.products-lambda-permissions.arn
  roles = [aws_iam_role.products-lambda.name]
}

resource "aws_iam_role" "products-lambda" {
  name = "products-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
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

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  runtime = "java17"
  handler = "com.david.StreamLambdaHandler::handleRequest"

  source_code_hash = var.source_code_hash

  role = aws_iam_role.products-lambda.arn
}