
// Provider variables
variable "region" {
  type = string
  default = "eu-central-1"
}


// Instance variables
variable "server_instance" {
  type = string
  default = "t2.micro"
}

// SSH key variables
variable "publickeypath" {
  type = string
  default = "/home/romario/.ssh/aws_terr_key.pub"
}

variable "privatekeypath" {
  type = string
  default = "/home/romario/.ssh/aws_terr_key"
}

// VPC vars

variable "vpc_cidr" {
  type = string
  default = "10.10.0.0/16"
}

variable "public_cidr" {
  type = string
  default = "10.10.1.0/24"
}

variable "public_cidr1" {
  type = string
  default = "10.10.2.0/24"
}

variable "private_cidr" {
  type = string
  default = "10.10.10.0/24"
}
variable "private_cidr1" {
  type = string
  default = "10.10.20.0/24"
}

// Tag vars
variable "project_name" {
  type = string
  default = "Сomplex_project"
}