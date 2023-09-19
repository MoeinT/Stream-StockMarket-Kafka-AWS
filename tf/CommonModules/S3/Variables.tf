variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "auth" {
  type = map(string)
}

variable "allBuckets" {
  type = map(any)
}

variable "env" {
  type = string
}