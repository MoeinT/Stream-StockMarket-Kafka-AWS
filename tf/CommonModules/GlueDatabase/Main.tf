terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.auth.access_key
  secret_key = var.auth.secret_key
}


# Creating roles
resource "aws_glue_catalog_database" "AllDatabases" {
  for_each = toset(var.allDatabases)
  name     = each.key
}