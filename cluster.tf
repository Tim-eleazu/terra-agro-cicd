resource "aws_eks_cluster" "tac_eks_cluster" {
  name     = var.tac_eks_cluster
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.tac_public_subnet.*.id

  }

  tags = {
    Name = var.tac_eks_cluster
  }
}