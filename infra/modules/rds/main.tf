terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }
}

data "aws_region" "current" {}

locals {
  subnet_group = "${var.name_prefix}-db-subnets"
  db_instance = "${var.name_prefix}-mysql-db"
  db_name = join("", [replace(var.name_prefix, "-", ""), "mysqldb"])
}

resource "aws_db_subnet_group" "db_subnets" {
  name = local.subnet_group
  subnet_ids = var.subnet_ids
  tags = {
    Name = local.subnet_group
  }
}

resource "aws_security_group" "mysql_sg" {
  name = "${var.name_prefix}-public-mysql"
  description = "Allows public MySQL access"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow MySQL"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.name_prefix}-public-mysql"
  }
}

resource "aws_db_instance" "mysql" {
  identifier = local.db_instance
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  port = 3306
  db_name = local.db_name
  username = "rds_admin"
  password = "SuperSecretPass(12345)"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  tags = {
    Name = local.db_instance
  }
}
