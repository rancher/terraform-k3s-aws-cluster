terraform {
  required_providers {
    rancher2 = ">= 1.6.0"
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "r53"
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  name                        = var.name
  install_k3s_version         = var.install_k3s_version
  k3s_cluster_secret          = var.k3s_cluster_secret != null ? var.k3s_cluster_secret : random_password.k3s_cluster_secret.result
  server_instance_type        = var.server_instance_type
  agent_instance_type         = var.agent_instance_type
  storage_cafile              = var.storage_cafile
  agent_image_id              = var.agent_image_id != null ? var.agent_image_id : data.aws_ami.ubuntu.id
  server_image_id             = var.server_image_id != null ? var.server_image_id : data.aws_ami.ubuntu.id
  aws_azs                     = var.aws_azs
  public_subnets              = length(var.public_subnets) > 0 ? var.public_subnets : data.aws_subnet_ids.available.ids
  private_subnets             = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnet_ids.available.ids
  server_node_count           = var.server_node_count
  agent_node_count            = var.agent_node_count
  ssh_keys                    = var.ssh_keys
  db_instance_type            = var.db_instance_type
  db_user                     = var.db_user
  db_pass                     = var.db_pass
  db_name                     = var.db_name != null ? var.db_name : var.name
  db_node_count               = var.db_node_count
  server_k3s_exec             = "--disable-agent --no-deploy traefik --tls-san ${aws_lb.server-lb.dns_name} --storage-cafile /srv/rds-ca-2019-root.pem --storage-endpoint postgres://${local.db_user}:${local.db_pass}@${aws_rds_cluster.k3s.endpoint}/${local.db_name}"
  agent_k3s_exec              = ""
  certmanager_version         = var.certmanager_version
  rancher_version             = var.rancher_version
  letsencrypt_email           = var.letsencrypt_email
  domain                      = var.domain
  r53_domain                  = length(var.r53_domain) > 0 ? var.r53_domain : local.domain
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  public_subnets_cidr_blocks  = var.public_subnets_cidr_blocks
  skip_final_snapshot         = var.skip_final_snapshot
  install_certmanager         = var.install_certmanager
  install_rancher             = var.install_rancher
  install_ingress             = var.install_ingress
  create_external_nlb         = var.create_external_nlb ? 1 : 0
  registration_command        = var.registration_command
}

resource "random_password" "k3s_cluster_secret" {
  length  = 30
  special = false
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${local.name}.${local.domain}"
  bootstrap = true
}

provider "rancher2" {
  api_url   = "https://${local.name}.${local.domain}"
  token_key = rancher2_bootstrap.admin.token
}

resource "null_resource" "wait_for_rancher" {
  provisioner "local-exec" {
    command = <<EOF
while [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; do
    subject=$(curl -vk -m 2 "https://$${RANCHER_HOSTNAME}/ping" 2>&1 | grep "subject:")
    echo "Cert Subject Response: $${subject}"
    if [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; then
      sleep 10
    fi
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://$${RANCHER_HOSTNAME}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF


    environment = {
      RANCHER_HOSTNAME = "${local.name}.${local.domain}"
    }
  }
  depends_on = [
    aws_autoscaling_group.k3s_server,
    aws_autoscaling_group.k3s_agent,
    aws_rds_cluster_instance.k3s,
    aws_route53_record.rancher
  ]
}

resource "rancher2_bootstrap" "admin" {
  provider   = rancher2.bootstrap
  password   = var.rancher_password
  depends_on = [null_resource.wait_for_rancher]
}
