module "kube" {
  source = "../../"

  network_id = "enpemhfq3bg3i9f0vxxx"

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9bt2qj2vufbh273pxxx"
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "20:00"
      duration   = "3h"
    }
  ]

  master_scale_policy = {
    auto_scale = {
      min_resource_preset_id = "s-c2-m8"
    }
  }

  node_groups = {
    "yc-k8s-ng" = {
      description = "Kubernetes node group with fixed size scaling"
      fixed_scale = {
        size = 2
      }
    }
  }
}

module "addons" {
  source = "github.com/terraform-yc-modules/terraform-yc-kubernetes-marketplace"

  cluster_id = module.kube.cluster_id

  install_nodelocal_dns = true

  # Full usage example:
  # https://github.com/terraform-yc-modules/terraform-yc-kubernetes-marketplace/tree/main/examples/full
}
