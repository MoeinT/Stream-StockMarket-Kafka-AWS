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

# S3 buckets
resource "aws_s3_bucket" "AllBuckets" {
  for_each = var.allBuckets

  bucket        = each.value.bucket
  force_destroy = lookup(each.value, "force_destroy", false)

  tags = {
    Name        = each.key
    Environment = var.env
  }
}

# Conditionally Enable server side encryption for all S3 buckets
resource "aws_s3_bucket_server_side_encryption_configuration" "S3Encryption" {
  for_each = var.allBuckets

  bucket = aws_s3_bucket.AllBuckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}