module "kube" {
  source = "../../"

  network_id = "enpneopbt180nusgut3q"

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9b5udt8asf9r9qn6nf6"
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
      description = "Kubernetes nodes group 01 with fixed 1 size scaling"
      auto_scale = {
        min     = 2
        max     = 4
        initial = 2
      }
    },
    "yc-k8s-ng-02" = {
      description = "Kubernetes nodes group 02 with auto scaling"
      fixed_scale = {
        size = 3
      }
    }
  }
}
