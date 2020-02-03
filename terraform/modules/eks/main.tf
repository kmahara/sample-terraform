data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.10"
}

# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/8.1.0
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.name
  subnets         = var.subnets
  vpc_id          = var.vpc_id
  config_output_path = var.config_output_path

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = var.worker_instance_type
      asg_desired_capacity          = var.asg_desired_capacity
      asg_max_size                  = var.asg_max_size
      autoscaling_enabled           = var.autoscaling_enabled
      # ami_type  = "AL2_x86_64"
      # disk_size = 20
      # additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
  ]

  # worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}
