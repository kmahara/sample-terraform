variable "aws" {
  type = map(string)
  default = {
    profile    = ""
    region     = ""
    access_key = ""
    secret_key = ""
  }
}

variable "service_name" {
  type = string
}

variable "stage" {
  type = string
  description = "dev, std, prd"
}
