locals {
  auth = {
    "access_key" : var.access_key
    "secret_key" : var.secret_key
  }

  assume_aws_glue_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "glue.amazonaws.com"
        }
      }
    ]
  }
EOF
}