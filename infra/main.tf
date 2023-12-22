terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }
}

provider "aws" {
  alias = "frankfurt"
  region = "eu-central-1"
  profile = "terraform"
}

module "vpc" {
  source = "./modules/vpc"
  providers = {
    aws = aws.frankfurt
  }
  name_prefix = "devops-finals"
  vpc_cidr_block = "10.10.0.0/16"
  public_subnet_cidr_block = "10.10.1.0/24"
  first_private_subnet_cidr_block = "10.10.2.0/24"
  second_private_subnet_cidr_block = "10.10.3.0/24"
}

module "eks_cluster" {
  source = "./modules/eks-cluster"
  providers = {
    aws = aws.frankfurt
  }
  name_prefix = "devops-finals"
  subnet_ids = [module.vpc.first_private_subnet_id, module.vpc.second_private_subnet_id]
}