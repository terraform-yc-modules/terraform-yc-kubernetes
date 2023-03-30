# kube-01
output "kube01_cluster_id" {
  description = "Kubernetes 01 cluster ID."
  value       = try(module.kube-01.cluster_id, null)
}

output "kube01_cluster_name" {
  description = "Kubernetes 01 cluster name."
  value       = try(module.kube-01.cluster_name, null)
}

output "kube01-external_cluster_cmd_str" {
  description = "Connection string to external Kubernetes 01 cluster."
  value       = try(module.kube-01.external_cluster_cmd, null)
}

output "kube01-internal_cluster_cmd_str" {
  description = "Connection string to internal Kubernetes 01 cluster."
  value       = try(module.kube-01.internal_cluster_cmd, null)
}

# kube-02
output "kube02_cluster_id" {
  description = "Kubernetes cluster ID."
  value       = try(module.kube-02.cluster_id, null)
}

output "kube02_cluster_name" {
  description = "Kubernetes cluster name."
  value       = try(module.kube-02.cluster_name, null)
}

output "kube02-external_cluster_cmd_str" {
  description = "Connection string to external Kubernetes 02 cluster"
  value       = try(module.kube-02.external_cluster_cmd, null)
}

output "kube02-internal_cluster_cmd_str" {
  description = "Connection string to internal Kubernetes 02 cluster"
  value       = try(module.kube-02.internal_cluster_cmd, null)
}