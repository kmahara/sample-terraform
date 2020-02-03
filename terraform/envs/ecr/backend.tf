terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    bucket  = "sample-terraform2"
    key     = "dev-ecr"
    encrypt = "true"
    dynamodb_table = "sample-terraform2-lock"
    region  = "ap-southeast-1"
    # profile = "company"
  }
}
