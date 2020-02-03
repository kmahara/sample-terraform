output "ecr_repository_uri" {
  value = module.ecr.ecr_repository_uri
}

output "bastion" {
  value = module.bastion.public_ip
}
