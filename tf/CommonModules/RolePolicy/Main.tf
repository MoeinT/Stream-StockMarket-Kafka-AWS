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


# Creating Role Policies 
resource "aws_iam_role_policy_attachment" "AllPolicies" {
  for_each = var.policies

  role       = each.value.role
  policy_arn = each.value.policy_arn
}