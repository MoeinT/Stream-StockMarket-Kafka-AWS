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


# S3 notifications
resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = var.allS3Notifications
  bucket   = each.value.bucket

  dynamic "lambda_function" {
    for_each = contains(keys((each.value)), "lambda_function") ? [1] : []
    content {
      lambda_function_arn = each.value.lambda_function.lambda_function_arn
      events              = each.value.lambda_function.events
      filter_prefix       = each.value.lambda_function.filter_prefix
      filter_suffix       = each.value.lambda_function.filter_suffix
    }
  }
}