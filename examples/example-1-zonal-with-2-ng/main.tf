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

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01 with auto scaling"
      auto_scale = {
        min     = 2
        max     = 4
        initial = 2
      }
    },
    "yc-k8s-ng-02" = {
      description = "Kubernetes nodes group 02 with fixed size scaling"
      fixed_scale = {
        size = 3
      }
    }
  }
}
