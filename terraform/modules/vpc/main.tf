# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.22.0
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = "${var.cidr-prefix}.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["${var.cidr-prefix}.96.0/19", "${var.cidr-prefix}.128.0/19", "${var.cidr-prefix}.160.0/19"]
  public_subnets  = ["${var.cidr-prefix}.0.0/19" , "${var.cidr-prefix}.32.0/19" , "${var.cidr-prefix}.64.0/19"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
