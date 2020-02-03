# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.3.0
## ingress/engress での定義済み名前一覧
# https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
module "bastion-security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.name}-securiry_group"
  description = "Security group for bastion EC2 instance"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules       = ["all-icmp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_cidr_block
    },
  ]

  egress_cidr_blocks = ["10.10.0.0/16"]
  egress_rules = ["all-all"]
}

module "bastion" {
  source                 = "terraform-aws-modules/ec2-instance/aws"

  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [module.bastion-security_group.this_security_group_id]
  associate_public_ip_address = true
  subnet_id              = var.subnet_id
}
