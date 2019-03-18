variable "region" {
  default = "us-east-1"
}

variable "environment" {
  description = ""
  default     = "testing"
}

variable "organization" {
  description = ""
  default     = "Orgtesting"
}

variable "vpc_cidr" {
  description = ""
  default     = "172.168.0.0/16"
}
