module "kube" {
  source = "../../"

  network_id = "enp9rm1debn7usfmtlnv"

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9btfjlqo7dpjofkho1j"
    },
    {
      zone      = "ru-central1-b"
      subnet_id = "e2l5ia8ggm3e8n99a6b2"
    },
    {
      zone      = "ru-central1-d"
      subnet_id = "fl87ermplm09vqhcnnt7"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01"
      auto_scale = {
        min     = 2
        max     = 4
        initial = 2
      }
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-01"
        environment = "testing"
      }
    },
    "yc-k8s-ng-02" = {
      description = "Kubernetes nodes group 02"
      auto_scale = {
        min     = 3
        max     = 5
        initial = 3
      }
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-02"
        environment = "testing"
      }
    },
    "yc-k8s-ng-03" = {
      description = "Kubernetes nodes group 03"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-03"
        environment = "testing"
      }
    },
    "yc-k8s-ng-04" = {
      description = "Kubernetes nodes group 04"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      node_locations = [
        {
          zone      = "ru-central1-d"
          subnet_id = "fl8788ou1fs1111epdc4"
        }
      ]
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-04"
        environment = "testing"
      }
    },
    "yc-k8s-ng-05" = {
      description = "Kubernetes nodes group 05"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-05"
        environment = "testing"
      }
    },
    "yc-k8s-ng-06" = {
      description = "Kubernetes nodes group 06"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      node_locations = [
        {
          zone      = "ru-central1-b"
          subnet_id = "e2l4uju9nsorr7jhcegu"
        }
      ]
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-06"
        environment = "testing"
      }
    },
    "yc-k8s-ng-07" = {
      description = "Kubernetes nodes group 07"
      fixed_scale = {
        size = 3
      }
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-07"
        environment = "testing"
      }
    }
  }
}
