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
  private_subnet_cidr_block = "10.10.2.0/24"
}
