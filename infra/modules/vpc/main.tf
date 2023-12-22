terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }
}

data "aws_region" "current" {}

resource "aws_vpc" "created_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.created_vpc.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block = var.public_subnet_cidr_block
  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}

resource "aws_subnet" "first_private_subnet" {
  vpc_id = aws_vpc.created_vpc.id
  availability_zone = "${data.aws_region.current.name}b"
  cidr_block = var.first_private_subnet_cidr_block
  tags = {
    Name = "${var.name_prefix}-1st-private-subnet"
  }
}

resource "aws_subnet" "second_private_subnet" {
  vpc_id = aws_vpc.created_vpc.id
  availability_zone = "${data.aws_region.current.name}c"
  cidr_block = var.second_private_subnet_cidr_block
  tags = {
    Name = "${var.name_prefix}-2nd-private-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.created_vpc.id
  tags = {
    Name = "${var.name_prefix}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.created_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.name_prefix}-public-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "elastic_ip_for_nat" {
  domain = "vpc"
  tags = {
    Name = "${var.name_prefix}-elastic-ip-for-nat-gateway"
  }
}

resource "aws_nat_gateway" "nat_for_private_subnet" {
  allocation_id = aws_eip.elastic_ip_for_nat.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "${var.name_prefix}-nat-gateway-for-private-subnet"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.created_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_for_private_subnet.id
  }
  tags = {
    Name = "${var.name_prefix}-private-route-table"
  }
}

resource "aws_route_table_association" "first_private_route_table_association" {
  subnet_id = aws_subnet.first_private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "second_private_route_table_association" {
  subnet_id = aws_subnet.second_private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
