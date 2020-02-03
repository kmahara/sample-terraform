variable "aws" {
  type = map(string)
  default = {
    profile    = ""
    region     = ""
    access_key = ""
    secret_key = ""
  }
}
