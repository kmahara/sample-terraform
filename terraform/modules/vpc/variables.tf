variable "name" {
  type = string
  description = "VPC name"
}

variable "cidr-prefix" {
  type = string
  default = "192.168"
}

variable "aws_region" {
  type = string
}
