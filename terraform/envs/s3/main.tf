provider "aws" {
  region     = var.aws.region
  profile    = contains(keys(var.aws), "profile") ? var.aws.profile : ""
  access_key = contains(keys(var.aws), "access_key") ? var.aws.access_key : ""
  secret_key = contains(keys(var.aws), "secret_key") ? var.aws.secret_key : ""
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "sample-terraform2"
  acl = "private"

  versioning {
    enabled = true
  }

  # 古いバージョンを消す場合
/*
  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7

    noncurrent_version_expiration {
      days = 32
    }
  }
*/
}

resource "aws_dynamodb_table" "tfstate" {
  name           = "sample-terraform2-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"      # S = String
  }
}
