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
resource "aws_glue_crawler" "AllGlueCrawlers" {
  for_each      = var.allCrawlers
  database_name = each.value.database_name
  name          = each.value.glue_crawler_name
  role          = each.value.role
  tags          = contains(keys(each.value), "tags") ? each.value.tags : null

  dynamic "s3_target" {
    for_each = contains(keys((each.value)), "s3_target") ? [1] : []
    content {
      path = each.value.s3_target.path
    }
  }

  dynamic "jdbc_target" {
    for_each = contains(keys((each.value)), "jdbc_target") ? [1] : []
    content {
      connection_name = each.value.jdbc_target.connection_name
      path            = each.value.jdbc_target.path
    }
  }

  dynamic "dynamodb_target" {
    for_each = contains(keys((each.value)), "dynamodb_target") ? [1] : []
    content {
      path = each.value.dynamodb_target.path
    }
  }

  dynamic "mongodb_target" {
    for_each = contains(keys((each.value)), "mongodb_target") ? [1] : []
    content {
      connection_name = each.value.mongodb_target.connection_name
      path            = each.value.mongodb_target.path
    }
  }
}

