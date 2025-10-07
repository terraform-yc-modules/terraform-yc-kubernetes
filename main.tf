data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id

  # For backward compatibility
  effective_master_sg_ids = length(var.master_security_group_ids_list) > 0 ? var.master_security_group_ids_list : var.security_groups_ids_list

  master_security_groups_list = concat(local.effective_master_sg_ids, var.enable_default_rules == true ? [
    yandex_vpc_security_group.k8s_main_sg[0].id,
    yandex_vpc_security_group.k8s_master_whitelist_sg[0].id
  ] : [])

  # Merging master labels with node group labels
  node_groups_labels = concat([
    for i, v in tolist(keys(var.node_groups)) : lookup(var.node_groups[v], "labels", {})
  ])
  merged_node_labels_with_master = merge(zipmap(
    flatten([for item in local.node_groups_labels : keys(item)]),
    flatten([for item in local.node_groups_labels : values(item)])
  ), var.master_labels)
}

resource "time_sleep" "wait_for_iam" {
  create_duration = "5s"
  depends_on = [
    yandex_resourcemanager_folder_iam_member.sa_calico_network_policy_role,
    yandex_resourcemanager_folder_iam_member.sa_cilium_network_policy_role,
    yandex_resourcemanager_folder_iam_member.sa_node_group_public_role_admin,
    yandex_resourcemanager_folder_iam_member.sa_node_group_loadbalancer_role_admin,
    yandex_resourcemanager_folder_iam_member.sa_public_loadbalancers_role,
    yandex_resourcemanager_folder_iam_member.sa_logging_writer_role,
    yandex_resourcemanager_folder_iam_member.node_account
  ]
}

resource "yandex_kubernetes_cluster" "kube_cluster" {
  name                     = "${var.cluster_name}-${random_string.unique_id.result}"
  description              = var.description
  folder_id                = local.folder_id
  network_id               = var.network_id
  labels                   = try(local.merged_node_labels_with_master, {})
  cluster_ipv4_range       = var.cluster_ipv4_range
  cluster_ipv6_range       = var.cluster_ipv6_range
  node_ipv4_cidr_mask_size = var.node_ipv4_cidr_mask_size
  service_ipv4_range       = var.service_ipv4_range
  service_ipv6_range       = var.service_ipv6_range
  service_account_id       = local.create_sa ? var.master_service_account_id : yandex_iam_service_account.master[0].id
  node_service_account_id  = local.create_sa ? var.node_service_account_id : yandex_iam_service_account.node_account[0].id
  network_policy_provider  = var.enable_cilium_policy ? null : var.network_policy_provider
  release_channel          = var.release_channel

  dynamic "kms_provider" {
    for_each = var.create_kms ? compact([try(yandex_kms_symmetric_key.kms_key[0].id, null)]) : []
    content {
      key_id = kms_provider.value
    }
  }

  dynamic "network_implementation" {
    for_each = var.enable_cilium_policy ? ["cilium"] : []
    content {
      cilium {}
    }
  }

  master {
    version            = var.cluster_version
    public_ip          = var.public_access
    security_group_ids = local.master_security_groups_list

    dynamic "master_location" {
      for_each = var.master_locations
      content {
        subnet_id = master_location.value["subnet_id"]
        zone      = master_location.value["zone"]
      }
    }

    dynamic "scale_policy" {
      for_each = var.master_scale_policy != null ? [var.master_scale_policy] : []
      content {
        auto_scale {
          min_resource_preset_id = scale_policy.value
        }
      }
    }

    maintenance_policy {
      auto_upgrade = var.master_auto_upgrade

      dynamic "maintenance_window" {
        for_each = var.master_maintenance_windows
        content {
          day        = maintenance_window.value.day
          start_time = maintenance_window.value.start_time
          duration   = maintenance_window.value.duration
        }
      }
    }

    master_logging {
      enabled                    = var.master_logging.enabled
      folder_id                  = var.master_logging.log_group_id == null ? local.folder_id : null
      kube_apiserver_enabled     = var.master_logging.enabled_kube_apiserver
      cluster_autoscaler_enabled = var.master_logging.enabled_autoscaler
      events_enabled             = var.master_logging.enabled_events
      audit_enabled              = var.master_logging.enabled_audit
      log_group_id               = var.master_logging.log_group_id
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.node_account,
    yandex_resourcemanager_folder_iam_member.sa_calico_network_policy_role,
    yandex_resourcemanager_folder_iam_member.sa_cilium_network_policy_role,
    yandex_resourcemanager_folder_iam_member.sa_node_group_public_role_admin,
    yandex_resourcemanager_folder_iam_member.sa_node_group_loadbalancer_role_admin,
    yandex_resourcemanager_folder_iam_member.sa_logging_writer_role,
    yandex_resourcemanager_folder_iam_member.sa_public_loadbalancers_role,
    time_sleep.wait_for_iam
  ]

}
