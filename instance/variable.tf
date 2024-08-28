variable "ami" {
  type    = string
  default = "ami-0e86e20dae9224db8"
}

variable "type" {
  type    = string
  default = "t2.micro"
}

variable "Bastion-SG" {
  type = string
}

variable "Application-SG" {
  type = string
}

variable "PublicSubnet1" {

}

variable "PublicSubnet2" {

}

variable "privateSubnet1" {

}

variable "privateSubnet2" {

}

variable "db_user" {
  default = "admin"
}

variable "db_name" {
  default = "wordpress"
}

variable "db_pswd" {
  default = "mysql200"
}

variable "db_endpoint" {

}

