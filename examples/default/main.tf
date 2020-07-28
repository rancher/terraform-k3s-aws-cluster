provider "aws" {
  region  = "us-west-2"
  profile = "rancher-eng"
}

provider "aws" {
  alias   = "r53"
  region  = "us-west-2"
  profile = "rancher-eng"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = "example"
  cidr = "10.105.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.105.1.0/24", "10.105.2.0/24", "10.105.3.0/24"]
  private_subnets = ["10.105.4.0/24", "10.105.5.0/24", "10.105.6.0/24"]

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  tags = {
    "Name" = "example"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "bastion" {
  name   = "example-bastion"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.public_subnets, 0)
  user_data     = templatefile("${path.module}/bastion.tmpl", { ssh_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak"] })

  vpc_security_group_ids = [aws_security_group.bastion.id, module.vpc.default_security_group_id]

  tags = {
    Name = "example-bastion"
  }
}

provider "rancher2" {
  api_url   = "https://example.eng.rancher.space"
  token_key = "token-4hdgv:zsgmrtqhzf4rf5l7tp6vv6fpxv8jwdxntwsk2bq7mwgmbv8kcg5lsf"
}

resource "rancher2_cluster" "k3s" {
  name = "example-imported"
}

module "k3s_rancher" {
  source                       = "../../"
  vpc_id                       = module.vpc.vpc_id
  aws_region                   = "us-west-2"
  aws_profile                  = "rancher-eng"
  private_subnets              = module.vpc.private_subnets
  public_subnets               = module.vpc.public_subnets
  ssh_keys                     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak"]
  name                         = "example"
  k3s_cluster_secret           = "secretvaluechangeme"
  domain                       = "eng.rancher.space"
  aws_azs                      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  k3s_storage_endpoint         = "postgres"
  db_user                      = "exampleuser"
  db_pass                      = "mD,50cbf5597fd320b6a732ce778082a0359"
  extra_server_security_groups = [module.vpc.default_security_group_id]
  extra_agent_security_groups  = [module.vpc.default_security_group_id]
  private_subnets_cidr_blocks  = module.vpc.private_subnets_cidr_blocks
  registration_command         = rancher2_cluster.k3s.cluster_registration_token[0].command
  providers = {
    aws     = aws
    aws.r53 = aws.r53
  }
}
