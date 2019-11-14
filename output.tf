output "rancher_admin_password" {
  value     = local.install_rancher ? local.rancher_password : null
  sensitive = true
}

output "rancher_url" {
  value = local.install_rancher ? rancher2_bootstrap.admin.0.url : null
}

output "rancher_token" {
  value     = local.install_rancher ? rancher2_bootstrap.admin.0.token : null
  sensitive = true
}

output "external_lb_dns_name" {
  value = local.create_external_nlb > 0 ? aws_lb.lb.0.dns_name : null
}

output "k3s_cluster_secret" {
  value     = local.k3s_cluster_secret
  sensitive = true
}
