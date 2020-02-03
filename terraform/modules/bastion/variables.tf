variable "name" {
  type = string
  description = "EC2 instance name"
}

variable "ingress_cidr_blocks" {
  type = list(string)
  default = ["0.0.0.0/0"]
  description = "default ingress cidr blocks. accept ICMP from this"
}

variable "ssh_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "ami" {
  type = string
  description = "ami instance id"
}

variable "instance_type" {
  type = string
  default = "t3.nano"
  description = "EC2 instance type"
}

variable "key_name" {
  type = string
  description = "ssh public key for login"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}
