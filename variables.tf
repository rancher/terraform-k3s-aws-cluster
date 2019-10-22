variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user during bootstrap of Rancher Server"
}

variable "rancher_version" {
  type        = string
  default     = "2.3.1"
  description = "Version of Rancher to install"
}

variable "agent_image_id" {
  type        = string
  default     = null
  description = "AMI to use for k3s agent instances"
}

variable "server_image_id" {
  type        = string
  default     = null
  description = "AMI to use for k3s server instances"
}

variable "ssh_keys" {
  type        = list
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "rancher_chart" {
  type        = string
  default     = "rancher-stable/rancher"
  description = "Helm chart to use for Rancher install"
}

variable "name" {
  type        = string
  default     = "rancher-demo"
  description = "Name for deployment"
}

variable "letsencrypt_email" {
  type        = string
  default     = "none@none.com"
  description = "LetsEncrypt email address to use"
}

variable "domain" {
  type    = string
  default = "eng.rancher.space"
}

variable "r53_domain" {
  type        = string
  default     = ""
  description = "DNS domain for Route53 zone (defaults to domain if unset)"
}

variable "server_instance_type" {
  type    = string
  default = "m5.large"
}

variable "agent_instance_type" {
  type    = string
  default = "m5.large"
}

variable "server_node_count" {
  type        = number
  default     = 1
  description = "Number of server nodes to launch"
}

variable "agent_node_count" {
  type        = number
  default     = 3
  description = "Number of agent nodes to launch"
}

variable "db_node_count" {
  type        = number
  default     = 1
  description = "Number of RDS database instances to launch"
}

variable "server_instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "agent_instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "certmanager_version" {
  type        = string
  default     = "0.9.1"
  description = "Version of cert-manager to install"
}

variable "use_default_vpc" {
  type        = bool
  default     = false
  description = "Should the default VPC for the region selected be used for Rancher"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "If use_default_vpc is false, the vpc id that Rancher should use"
}

variable "aws_region" {
  type    = string
  default = null
}

variable "aws_profile" {
  type        = string
  default     = null
  description = "Name of the AWS Profile to use for authentication"
}

variable "public_subnets" {
  default     = []
  type        = list
  description = "List of public subnet ids."
}

variable "private_subnets" {
  default     = []
  type        = list
  description = "List of private subnet ids."
}

variable "install_k3s_version" {
  default     = "0.9.1"
  type        = string
  description = "Version of K3S to install"
}

variable "k3s_cluster_secret" {
  default     = null
  type        = string
  description = "Override to set k3s cluster registration secret"
}

variable "extra_server_security_groups" {
  default     = []
  type        = list
  description = "Additional security groups to attach to k3s server instances"
}

variable "extra_agent_security_groups" {
  default     = []
  type        = list
  description = "Additional security groups to attach to k3s agent instances"
}

variable "aws_azs" {
  default     = null
  type        = list
  description = "List of AWS Availability Zones in the VPC"
}

variable "db_instance_type" {
  default = "db.r5.large"
}

variable "db_name" {
  default     = null
  type        = string
  description = "Name of database to create in RDS"
}

variable "db_user" {
  type        = string
  description = "Username for RDS database"
}

variable "db_pass" {
  type        = string
  description = "Password for RDS user"
}

variable "private_subnets_cidr_blocks" {
  default     = []
  type        = list
  description = "List of cidr_blocks of private subnets"
}

variable "public_subnets_cidr_blocks" {
  default     = []
  type        = list
  description = "List of cidr_blocks of public subnets"
}

variable "skip_final_snapshot" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not the final snapshot should be created on RDS cluster deletion"
}

variable "install_rancher" {
  default     = false
  type        = bool
  description = "Boolean that defines whether or not to install Rancher"
}

variable "install_nginx_ingress" {
  default     = false
  type        = bool
  description = "Boolean that defines whether or not to install nginx-ingress"
}

variable "install_certmanager" {
  default     = false
  type        = bool
  description = "Boolean that defines whether or not to install Cert-Manager"
}

variable "create_external_nlb" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to create an external load balancer"
}

variable "k3s_storage_cafile" {
  default     = "/srv/rds-combined-ca-bundle.pem"
  type        = string
  description = "Location to download RDS CA Bundle"
}

variable "registration_command" {
  default     = ""
  type        = string
  description = "Registration command to import cluster into Rancher. Should not be used when installing Rancher in this same cluster"
}

variable "k3s_storage_endpoint" {
  default     = "sqlite"
  type        = string
  description = "Storage Backend for K3S cluster to use. Valid options are 'sqlite' or 'postgres'"
}

variable "k3s_disable_agent" {
  default     = true
  type        = bool
  description = "Whether to run the k3s agent on the same host as the k3s server"
}

variable "k3s_tls_san" {
  default     = null
  type        = string
  description = "Sets k3s tls-san flag to this value instead of the default load balancer"
}

variable "k3s_deploy_traefik" {
  default     = true
  type        = bool
  description = "Configures whether to deploy traefik ingress or not"
}
