variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "AllLambdas" {
  type = map(any)
}

variable "auth" {
  type = map(string)
}