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

variable "private_subnet_cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the Private Subnet"
}

variable "subnet_ids" {
  type = list(string)
  default = []
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}
