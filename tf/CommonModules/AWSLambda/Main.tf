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
resource "aws_lambda_function" "test_lambda" {

  for_each         = var.AllLambdas
  filename         = each.value.filename
  function_name    = each.value.function_name
  role             = each.value.role
  handler          = each.value.handler
  timeout          = contains(keys(each.value), "timeout") ? each.value.timeout : 3
  source_code_hash = contains(keys(each.value), "source_code_hash") ? each.value.source_code_hash : null
  runtime          = each.value.runtime
  layers           = contains(keys(each.value), "layers") ? each.value.layers : []

  dynamic "environment" {
    for_each = contains(keys(each.value), "environment") ? [1] : []
    content {
      variables = each.value.environment
    }
  }
}