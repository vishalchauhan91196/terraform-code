provider "aws" {
  region  = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "app-tfstate-dev-123456789011"
    key     = "root/terraform.tfstate"
    region  = "us-east-1"
    dynamodb_table = "app-tfstate-lock-dev-123456789011"
  }
}