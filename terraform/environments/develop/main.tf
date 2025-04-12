# module "vpc" {
#   source  = "../../modules/vpc"
#   version = var.vpc.module_version
#
#   name           = var.vpc.name
#   cidr           = var.vpc.cidr
#   azs            = var.vpc.azs
#   public_subnets = var.vpc.public_subnets
# }
#
# module "rds" {
#   source = "../../modules/rds"
#
#   db_password    = var.rds.db_password
#   db_username    = var.rds.db_username
#   public_subnets = var.vpc.public_subnets
#   vpc_id         = module.vpc.vpc_id
# }

module "s3" {
  source        = "../../modules/s3"
  object_source = var.s3.object_source
  object_key    = var.s3.object_key
}

# module "lambda" {
#   source           = "../../modules/lambda"
#   s3_bucket        = module.s3.s3_bucket
#   s3_key           = module.s3.s3_key
#   source_code_hash = module.s3.s3_key
# }
#
# module "gateway" {
#   source     = "../../modules/gateway"
#   lambda_arn = module.lambda.lambda_arn
# }