resource "aws_s3_bucket" "products" {
  bucket        = "products-images-test"
  force_destroy = true

  tags = {
    Name        = "Products"
    Environment = "Test"
  }
}

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
#   key    = var.object_key
#   source = var.object_source
#
#   etag = filemd5(var.object_source)
# }