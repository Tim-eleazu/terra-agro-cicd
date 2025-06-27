resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.tac_eks_cluster.name}"
  }
  depends_on = [ aws_eks_cluster.tac_eks_cluster]
}


resource "helm_release" "argocd" {
  depends_on = [
    aws_eks_node_group.main,
    null_resource.update_kubeconfig
  ]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.5.2"
  namespace = "argocd"
  create_namespace = true

  values = [
    <<EOF
server:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
EOF
  ]
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = helm_release.argocd.namespace
  }
}