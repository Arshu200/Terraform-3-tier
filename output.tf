output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "BastionHost1" {
  value = module.instance.BastionHost1
}

output "BastionHost2" {
  value = module.instance.BastionHost2
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "app1-privateIp1" {
  value = module.instance.app1-privateIp1
}

output "app2-privateIp2" {
  value = module.instance.app2-privateIp2
}
