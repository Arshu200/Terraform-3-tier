variable "privateSubnet1" {

}

variable "privateSubnet2" {

}

variable "Application-SG" {

}

variable "ami" {

}

variable "type" {
  type    = string
  default = "t2.micro"
}

variable "target_group_arn" {

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

