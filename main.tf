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
  # db_host        = module.rds.rds-endpoint
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
  privateSubnet1  = module.vpc.Private-Subnet1
  privateSubnet2  = module.vpc.Private-Subnet2
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
  # db_host          = module.rds.rds-endpoint
}
