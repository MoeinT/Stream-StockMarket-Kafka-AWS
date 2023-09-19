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


# Lambda Permissions
resource "aws_lambda_permission" "allPermissions" {
  for_each      = var.allPermissions
  statement_id  = each.value.statement_id
  action        = each.value.action
  function_name = each.value.function_name
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}