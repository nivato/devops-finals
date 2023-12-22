variable "name_prefix" {
  type = string
  description = "The prefix to be used in Resource's Names"
}

variable "cluster_name" {
  type = string
  description = "Name of the EKS Cluster"
}

variable "subnet_ids" {
  type = list(string)
  default = []
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Group"
}

variable "desired_size" {
  type = number
  default = 2
  description = "Desired number of worker nodes"
}

variable "max_size" {
  type = number
  default = 2
  description = "Maximum number of worker nodes"
}

variable "min_size" {
  type = number
  default = 2
  description = "Minimum number of worker nodes"
}
