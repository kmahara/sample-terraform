terraform {
  required_version = ">= 0.12.20"
}

locals {
  name = "${var.stage}-${var.service_name}"
}

provider "aws" {
  region     = var.aws.region
  profile    = contains(keys(var.aws), "profile") ? var.aws.profile : ""
  access_key = contains(keys(var.aws), "access_key") ? var.aws.access_key : ""
  secret_key = contains(keys(var.aws), "secret_key") ? var.aws.secret_key : ""
}

module "ecr" {
  source = "../../modules/ecr"
  repository_name = local.name
}

module "vpc" {
  source = "../../modules/vpc"
  name = local.name
  aws_region = var.aws.region
}

resource "aws_key_pair" "default" {
  key_name   = local.name
  public_key = var.key_pair
}

module "bastion" {
  source = "../../modules/bastion"
  name = "${local.name}-bastion"
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.nano"
  key_name = aws_key_pair.default.key_name
  subnet_id = module.vpc.public_subnets[0]
  vpc_id = module.vpc.vpc_id
}

module "eks" {
  source = "../../modules/eks"
  name = local.name
  subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  config_output_path = "./out/"
  worker_instance_type = "t2.small"
  asg_desired_capacity = 1
  asg_max_size = 4
  autoscaling_enabled = true
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}
