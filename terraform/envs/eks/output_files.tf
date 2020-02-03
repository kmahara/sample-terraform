# ----

/*
data "template_file" "deployment" {
  template = file("../../templates/deployment.yaml")

  vars = {
    name           = "test"
    container_repository_uri = module.ecr.ecr_repository_uri
  }
}

resource "local_file" "deployment" {
  content  = data.template_file.deployment.rendered
  filename = "out/deployment.yaml"
  file_permission = 0644
}
*/

# ----

data "template_file" "shenv" {
  template = file("../../templates/env.sh")

  vars = {
    ecr_repository_uri = module.ecr.ecr_repository_uri
    service_name = var.service_name
    stage = var.stage
  }
}

resource "local_file" "shenv" {
  content  = data.template_file.shenv.rendered
  filename = "out/env.sh"
  file_permission = 0644
}

