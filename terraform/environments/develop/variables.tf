# variable "vpc" {
#   type = object({
#     module_version       = string
#     name                 = string
#     cidr                 = string
#     azs = list(string)
#     public_subnets = list(string)
#     enable_dns_support   = bool
#     enable_dns_hostnames = bool
#   })
# }
#
# variable "rds" {
#   type = object({
#     db_username = string
#     db_password = string
#   })
# }

variable "s3" {
  type = object({
    object_key    = string
    object_source = string
  })
}

# variable "lambda" {
#   type = object({
#
#   })
# }