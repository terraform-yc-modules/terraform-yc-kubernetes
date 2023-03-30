output "cluster_id" {
  description = "Kubernetes cluster ID."
  value       = try(yandex_kubernetes_cluster.kube_cluster.id, null)
}

output "cluster_name" {
  description = "Kubernetes cluster name."
  value       = try(yandex_kubernetes_cluster.kube_cluster.name, null)
}

# public ip with kube config download command 
output "external_cluster_cmd" {
  description = <<EOF
    Kubernetes cluster public IP address.
    Using following command to download kube config and start working with Yandex Managed Kubernetes cluster.
    $ yc managed-kubernetes cluster get-credentials --id <cluster_id> --external
    This command will automatically add kube config for your user and after that you could test it with
    <kubectl get cluster-info> command.
  EOF
  value = var.public_access ? "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.kube_cluster.id} --external" : null
}

# private ip with kube config download command
output "internal_cluster_cmd" {
  description = <<EOF
    Kubernetes cluster pricate IP address.
    Using following command to download kube config and start working with Yandex Managed Kubernetes cluster.
    $ yc managed-kubernetes cluster get-credentials --id <cluster_id> --internal
    NOTE: Be aware Kubernetes internal cluster nodes are available from nodes in the same subnet as cluster nodes!
  EOF
  value = var.public_access == false ? "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.kube_cluster.id} --internal" : null
}
