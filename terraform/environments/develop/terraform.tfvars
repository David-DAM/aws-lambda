vpc = {
  module_version       = "5.13"
  name                 = "products-vpc"
  cidr                 = "10.0.0.0/16"
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

rds = {
  db_username = "root"
  db_password = "password"
}


s3 = {
  object_key    = "products-lamba-code.zip"
  object_source = "../../target/aws-lambda-1.0-SNAPSHOT-lambda-package.zip"
}