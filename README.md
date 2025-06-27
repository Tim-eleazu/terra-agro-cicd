# terra-agro-cicd

# Vue Admin Web App (Kubernetes + ArgoCD)

This project contains the Kubernetes deployment configuration for the Vue Admin frontend application. It is configured for GitOps using ArgoCD.

## 🚀 Deployment Overview
The Vue app is containerized and deployed to an EKS cluster via Kubernetes manifests located in the `manifests/` directory. ArgoCD watches this directory and automatically syncs changes to the cluster.
