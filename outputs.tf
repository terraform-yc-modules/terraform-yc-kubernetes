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
    Use the following command to download kube config and start working with Yandex Managed Kubernetes cluster:
    `$ yc managed-kubernetes cluster get-credentials --id <cluster_id> --external`
    This command will automatically add kube config for your user; after that, you will be able to test it with the
    `kubectl get cluster-info` command.
  EOF
  value       = var.public_access ? "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.kube_cluster.id} --external" : null
}

# private ip with kube config download command
output "internal_cluster_cmd" {
  description = <<EOF
    Kubernetes cluster private IP address.
    Use the following command to download kube config and start working with Yandex Managed Kubernetes cluster:
    `$ yc managed-kubernetes cluster get-credentials --id <cluster_id> --internal`
    Note: Kubernetes internal cluster nodes are available from the virtual machines in the same VPC as cluster nodes.
  EOF
  value       = var.public_access == false ? "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.kube_cluster.id} --internal" : null
}

# The following output variables are for using with terraform providers such as kubernetes, helm, et cetera

# public cluster ip 
output "external_v4_address" {
  description = <<EOF
    Kubernetes cluster external IP address.
  EOF
  value       = var.public_access == true ? yandex_kubernetes_cluster.kube_cluster.master[0].external_v4_address : null
}

# private cluster ip 
output "internal_v4_address" {
  description = <<EOF
    Kubernetes cluster internal IP address.
    Note: Kubernetes internal cluster nodes are available from the virtual machines in the same VPC as cluster nodes.
  EOF
  value       = yandex_kubernetes_cluster.kube_cluster.master[0].internal_v4_address
}

# public cluster url
output "external_v4_endpoint" {
  description = <<EOF
    Kubernetes cluster external URL.
  EOF
  value       = var.public_access == true ? yandex_kubernetes_cluster.kube_cluster.master[0].external_v4_endpoint : null
}

# private cluster url
output "internal_v4_endpoint" {
  description = <<EOF
    Kubernetes cluster internal URL.
    Note: Kubernetes internal cluster nodes are available from the virtual machines in the same VPC as cluster nodes.
  EOF
  value       = yandex_kubernetes_cluster.kube_cluster.master[0].internal_v4_endpoint
}

# cluster CA certificate
output "cluster_ca_certificate" {
  description = <<EOF
    Kubernetes cluster certificate.
  EOF
  value       = yandex_kubernetes_cluster.kube_cluster.master[0].cluster_ca_certificate
}

# IAM node account name
output "node_account_name" {
  description = <<EOF
    Created IAM node account name.
  EOF
  value       = try(yandex_iam_service_account.node_account[0].name, "")
}

# IAM node account id
output "node_account_id" {
  description = <<EOF
    Created IAM node account ID.
  EOF
  value       = try(yandex_iam_service_account.node_account[0].id, "")
}

# IAM service account name
output "service_account_name" {
  description = <<EOF
    Created IAM service account name.
  EOF
  value       = try(yandex_iam_service_account.master[0].name, "")
}

# IAM service account id
output "service_account_id" {
  description = <<EOF
    Created IAM service account ID.
  EOF
  value       = try(yandex_iam_service_account.master[0].id, "")
}

# Nodes security group id
output "nodes_security_group_ids" {
  description = <<EOF
    Security groups IDs created for nodes in Kubernetes cluster.
  EOF
  value       = local.node_group_security_groups_list
}
