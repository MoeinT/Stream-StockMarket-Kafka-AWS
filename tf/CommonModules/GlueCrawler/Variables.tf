variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "auth" {
  type = map(string)
}

variable "allCrawlers" {
  type = any
}