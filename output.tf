output "rancher_admin_password" {
  value     = local.rancher_password
  sensitive = true
}

output "rancher_url" {
  value = local.install_rancher ? rancher2_bootstrap.admin.0.url : null
}

output "rancher_token" {
  value     = local.install_rancher ? rancher2_bootstrap.admin.0.token : null
  sensitive = true
}
