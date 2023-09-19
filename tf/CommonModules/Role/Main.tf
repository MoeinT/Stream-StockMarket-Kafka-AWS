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

resource "aws_iam_role" "AllRoles" {

  for_each = var.roles

  name               = each.value.name
  assume_role_policy = each.value.assume_role_policy

  tags = {
    tag-key = each.key
  }

  lifecycle {
    ignore_changes = [role_last_used.0.last_used_date]
  }
}