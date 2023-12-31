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
  cluster_name = "${var.name_prefix}-cluster"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.name_prefix}-EKSClusterRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7
  # ... potentially other configuration ...
}

resource "aws_eks_cluster" "created_cluster" {
  name = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    endpoint_public_access = true
    endpoint_private_access = true
    subnet_ids = var.subnet_ids
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy_attachment,
    aws_cloudwatch_log_group.eks_log_group
  ]
  tags = {
    Name = local.cluster_name
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.created_cluster.name
  addon_name = "vpc-cni"
  addon_version = "v1.14.1-eksbuild.1"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.created_cluster.name
  addon_name = "kube-proxy"
  addon_version = "v1.28.1-eksbuild.1"
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.created_cluster.name
  addon_name = "eks-pod-identity-agent"
  addon_version = "v1.0.0-eksbuild.1"
}
