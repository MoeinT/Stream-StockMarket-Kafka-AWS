
/* Creating an S3 bucket for the backend .tfstate file */
resource "aws_s3_bucket" "s3_tfstate" {
  bucket = "tfstate-backend-kafka-project"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform Backend"
  }
}

/* Enabling versioning for the backend .tftate file */
resource "aws_s3_bucket_versioning" "versioning_s3_tfstate" {
  bucket = aws_s3_bucket.s3_tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

/* Enabling server side encryption for the S3 bucket */
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_ss_encryption" {
  bucket = aws_s3_bucket.s3_tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

/* Using AWS DynamoDB to implement state locking */
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "kafka_project_state_locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}