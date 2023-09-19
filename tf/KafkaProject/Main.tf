terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    key            = "global/s3/staging.tfstate"
    bucket         = "tfstate-backend-kafka-project"
    region         = "eu-west-3"
    dynamodb_table = "kafka_project_state_locking"
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
}