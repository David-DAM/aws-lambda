module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = var.module_version

  name                 = var.name
  cidr                 = var.cidr
  azs                  = var.azs
  public_subnets       = var.public_subnets
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}