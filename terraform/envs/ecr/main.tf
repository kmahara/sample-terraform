locals {
  name = "${var.stage}-${var.service_name}"
}

provider "aws" {
  region     = var.aws.region
  profile    = contains(keys(var.aws), "profile") ? var.aws.profile : ""
  access_key = contains(keys(var.aws), "access_key") ? var.aws.access_key : ""
  secret_key = contains(keys(var.aws), "secret_key") ? var.aws.secret_key : ""
}

resource "aws_ecr_repository" "default" {
  name = local.name
}

