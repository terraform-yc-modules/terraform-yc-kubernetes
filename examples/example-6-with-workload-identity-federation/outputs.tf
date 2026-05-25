output "kube_cluster_id" {
  description = "Kubernetes cluster ID."
  value       = try(module.kube.cluster_id, null)
}

output "kube_cluster_name" {
  description = "Kubernetes cluster name."
  value       = try(module.kube.cluster_name, null)
}

output "external_cluster_cmd_str" {
  description = "Connection string to external Kubernetes cluster."
  value       = try(module.kube.external_cluster_cmd, null)
}

output "workload_identity_federation" {
  description = <<EOF
    Workload Identity Federation configuration of the cluster.
    Contains `issuer` and `jwks_uri` that can be used to configure
    external identity providers (AWS IAM OIDC, GCP, Azure AD, etc.).
  EOF
  value       = module.kube.workload_identity_federation
}

output "node_account_name" {
  description = "IAM node account name"
  value       = module.kube.node_account_name
}

output "service_account_name" {
  description = "IAM service account name"
  value       = module.kube.service_account_name
}
