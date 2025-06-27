data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.tac_eks_cluster
}


provider "kubernetes" {
  host                   = aws_eks_cluster.tac_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.tac_eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

resource "aws_eks_node_group" "main" {
  cluster_name    = var.tac_eks_cluster
  node_group_name = var.tac-node-group
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.tac_public_subnet.*.id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.tac_eks_cluster]

  tags = {
    Name = var.tac-node-group
  }
}