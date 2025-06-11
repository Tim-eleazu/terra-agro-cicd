locals {
  policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", # Grants the node permission to connect to the EKS cluster and function as a worker node.
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",                # Required for the Amazon VPC CNI plugin to manage networking for pods.
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]    # Allows the node to pull container images from Amazon ECR (Elastic Container Registry) in read-only mode.

  cluster_policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"] # essential for EKS cluster management.
}


resource "aws_iam_role" "eks_cluster_role" {
  name = var.tac_eks_role

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "eks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = {
    Name = var.tac_eks_role
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = local.cluster_policies[0]
}

resource "aws_iam_role" "eks_node_role" {
  name = var.tac_eks_node_role

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = {
    Name = var.tac_eks_node_role
  }
}

resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
  for_each   = toset(local.policies)
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}