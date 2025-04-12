variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type      = string
  sensitive = true
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}
