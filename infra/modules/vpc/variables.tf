variable "name_prefix" {
  type = string
  description = "The prefix to be used in Resource's Names"
}

variable "vpc_cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the VPC"
}

variable "public_subnet_cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the Public Subnet"
}

variable "first_private_subnet_cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the 1st Private Subnet"
}

variable "second_private_subnet_cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the 2nd Private Subnet"
}
