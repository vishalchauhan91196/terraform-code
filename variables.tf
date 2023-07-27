variable "region" {
  description = "AWS Region to use whilst provisioning this infrastructure"
  type        = string
}

variable "environment" {
  description = "AWS Target Infrastructure (prod or dev or qa)"
  type        = string
}

variable "rds_username" {
  description = "RDS username"
  type        = string
}

variable "rds_password" {
  description = "RDS Password"
  type        = string
}