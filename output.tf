output "argocd_initial_admin_secret" {
  description = "Command to get the ArgoCD initial admin password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}

output "argocd_server_load_balancer" {
  description = "Public URL of the ArgoCD web UI"
  value       = data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname
}

output "eks_connect" {
  description = "Command to connect kubectl to EKS"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.tac_eks_cluster.name}"
}