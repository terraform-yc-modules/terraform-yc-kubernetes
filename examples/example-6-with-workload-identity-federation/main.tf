module "kube" {
  source = "../../"

  network_id = "enp9rm1debn7usfmtlnv"

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9btfjlqo7dpjofkho1j"
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "20:00"
      duration   = "3h"
    }
  ]

  enable_workload_identity_federation = true

  node_groups = {
    "yc-k8s-ng-wif" = {
      description                  = "Node group with Workload Identity Federation enabled"
      workload_identity_federation = true
      fixed_scale = {
        size = 1
      }
    },
    "yc-k8s-ng-no-wif" = {
      description = "Node group without Workload Identity Federation"
      fixed_scale = {
        size = 1
      }
    }
  }
}
