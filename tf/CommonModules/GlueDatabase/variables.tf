variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "allDatabases" {
  type = list(string)
}

variable "auth" {
  type = map(string)
}