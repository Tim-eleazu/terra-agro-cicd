resource "aws_eks_cluster" "tac-eks-cluster" {
  name     = var.tac_eks_cluster
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.tac_public_subnet.*.id

  }

  tags = {
    Name = var.tac_eks_cluster
  }
}


resource "aws_eks_node_group" "tac-eks-node-group" {
  cluster_name    = var.tac_eks_cluster
  node_group_name = var.tac-node-group
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.tac_public_subnet.*.id


  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name = var.tac-node-group
  }
}