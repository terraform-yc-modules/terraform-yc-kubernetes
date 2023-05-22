# kube_01
output "kube01_cluster_id" {
  description = "Kubernetes 01 cluster ID."
  value       = try(module.kube_01.cluster_id, null)
}

output "kube01_cluster_name" {
  description = "Kubernetes 01 cluster name."
  value       = try(module.kube_01.cluster_name, null)
}

output "kube01_external_cluster_cmd_str" {
  description = "Connection string to external Kubernetes 01 cluster."
  value       = try(module.kube_01.external_cluster_cmd, null)
}

output "kube01_internal_cluster_cmd_str" {
  description = "Connection string to internal Kubernetes 01 cluster."
  value       = try(module.kube_01.internal_cluster_cmd, null)
}

# kube_02
output "kube02_cluster_id" {
  description = "Kubernetes cluster ID."
  value       = try(module.kube_02.cluster_id, null)
}

output "kube02_cluster_name" {
  description = "Kubernetes cluster name."
  value       = try(module.kube_02.cluster_name, null)
}

output "kube02_external_cluster_cmd_str" {
  description = "Connection string to external Kubernetes 02 cluster"
  value       = try(module.kube_02.external_cluster_cmd, null)
}

output "kube02_internal_cluster_cmd_str" {
  description = "Connection string to internal Kubernetes 02 cluster"
  value       = try(module.kube_02.internal_cluster_cmd, null)
}
