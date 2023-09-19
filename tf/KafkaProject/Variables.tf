variable "env" {
  description = "Environment for resources"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.env)
    error_message = "Environment should be either staging or prod."
  }
}

variable "access_key" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type      = string
  sensitive = true
}