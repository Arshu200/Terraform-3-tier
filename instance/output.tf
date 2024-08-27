output "BastionHost1" {
  value = aws_instance.Bastion-Host1.public_ip
}

output "BastionHost2" {
  value = aws_instance.Bastion-Host2.public_ip
}

output "app1-privateIp1" {
  value = aws_instance.app-server-1.id
}

output "app2-privateIp2" {
  value = aws_instance.app-server-2.id
}

