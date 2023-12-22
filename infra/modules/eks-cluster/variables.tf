variable "name_prefix" {
  type = string
  description = "The prefix to be used in Resource's Names"
}

variable "subnet_ids" {
  type = list(string)
  default = []
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}
