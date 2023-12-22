output "cluster_name" {
  value = aws_eks_cluster.created_cluster.name
}

output "cluster_id" {
  value = aws_eks_cluster.created_cluster.id
}

output "cluster_arn" {
  value = aws_eks_cluster.created_cluster.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.created_cluster.endpoint
}
