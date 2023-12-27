variable "name_prefix" {
  type = string
  description = "The prefix to be used in Resource's Names"
}

variable "vpc_id" {
  type = string
  description = "The VPC ID to associate with MySQL Security Group"
}

variable "subnet_ids" {
  type = list(string)
  default = []
  description = "A list of VPC subnet IDs to associate with the RDS DB subnet group"
}
