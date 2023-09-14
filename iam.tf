locals {
  iam_defaults = {
    service_account_name = "k8s-service-account-${random_string.unique_id.result}"
    node_account_name    = "k8s-node-account-${random_string.unique_id.result}"
  }
  create_sa = var.use_existing_sa && var.master_service_account_id != null && var.node_service_account_id != null ? true : false
}

resource "yandex_iam_service_account" "master" {
  count     = local.create_sa ? 0 : 1
  folder_id = local.folder_id
  name      = try("${var.service_account_name}-${random_string.unique_id.result}", local.iam_defaults.service_account_name)
}

resource "yandex_iam_service_account" "node_account" {
  count     = local.create_sa ? 0 : 1
  folder_id = local.folder_id
  name      = try("${var.node_account_name}-${random_string.unique_id.result}", local.iam_defaults.node_account_name)
}

resource "yandex_resourcemanager_folder_iam_member" "sa_calico_network_policy_role" {
  count     = var.enable_cilium_policy || local.create_sa ? 0 : 1
  folder_id = local.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.master[0].id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_cilium_network_policy_role" {
  count     = var.enable_cilium_policy && !local.create_sa ? 1 : 0
  folder_id = local.folder_id
  role      = "k8s.tunnelClusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.master[0].id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_node_group_public_role_admin" {
  count     = anytrue([for i, v in var.node_groups : lookup(v, "nat", var.node_groups_defaults.nat)]) && !local.create_sa ? 1 : 0
  folder_id = local.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.master[0].id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_node_group_loadbalancer_role_admin" {
  count     = anytrue([for i, v in var.node_groups : lookup(v, "nat", var.node_groups_defaults.nat)]) && !local.create_sa ? 1 : 0
  folder_id = local.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.master[0].id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_public_loadbalancers_role" {
  count     = var.allow_public_load_balancers && !local.create_sa ? 1 : 0
  folder_id = local.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.master[0].id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_logging_writer_role" {
  count     = var.master_logging.enabled && !local.create_sa ? 1 : 0
  folder_id = local.folder_id
  role      = "logging.writer"
  member    = "serviceAccount:${yandex_iam_service_account.master[0].id}"
}

resource "yandex_resourcemanager_folder_iam_member" "node_account" {
  count     = local.create_sa ? 0 : 1
  folder_id = local.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.node_account[0].id}"
}
