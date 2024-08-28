provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "instance" {
  source         = "./instance"
  Application-SG = module.vpc.Application-SG
  privateSubnet1 = module.vpc.Private-Subnet1
  privateSubnet2 = module.vpc.Private-Subnet2
  Bastion-SG     = module.vpc.Bastion-SG
  PublicSubnet1  = module.vpc.Public-Subnet1
  PublicSubnet2  = module.vpc.Public-Subnet2
  db_endpoint    = module.rds.db_endpoint
}


module "rds" {
  source         = "./rds"
  application-sg = module.vpc.Application-SG
  privateSubnet1 = module.vpc.Private-Subnet1
  privateSubnet2 = module.vpc.Private-Subnet2
}

module "alb" {
  source          = "./alb"
  Application-SG  = module.vpc.Application-SG
  vpc_id          = module.vpc.vpc_id
  publicSubnet1   = module.vpc.Public-Subnet1
  publicSubnet2   = module.vpc.Public-Subnet2
  private-server2 = module.instance.app2-privateIp2
  private-server1 = module.instance.app1-privateIp1
}

module "auto-scaling" {
  source           = "./auto-scaling"
  ami              = "ami-0e86e20dae9224db8"
  Application-SG   = module.vpc.Application-SG
  privateSubnet1   = module.vpc.Private-Subnet1
  privateSubnet2   = module.vpc.Private-Subnet2
  target_group_arn = module.alb.target_group_arn
  db_endpoint      = module.rds.db_endpoint
}

module "cdn" {
  source       = "./cloudfront"
  alb_dns_name = module.alb.alb_dns_name
}

# module "route53" {
#   source = "./route53"
  
# }
