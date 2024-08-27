output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "Public-Subnet1" {
  value = aws_subnet.publicSubnet1.id
}

output "Public-Subnet2" {
  value = aws_subnet.publicSubnet2.id
}

output "Private-Subnet1" {
  value = aws_subnet.privateSubnet1.id
}

output "Private-Subnet2" {
  value = aws_subnet.privateSubnet2.id
}

output "Bastion-SG" {
  value = aws_security_group.Bastion-SG.id
}

output "Application-SG" {
  value = aws_security_group.Private-SG.id
}

output "ALB-SG" {
  value = aws_security_group.ALB-SG.id
}
