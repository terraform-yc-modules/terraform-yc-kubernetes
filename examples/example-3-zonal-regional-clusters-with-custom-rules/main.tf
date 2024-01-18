module "kube_01" {
  source = "../../"

  cluster_name         = "kube-cluster-01"
  network_id           = "enpv53lp27m52o0be8lj"
  public_access        = false
  create_kms           = true
  service_account_name = "kube-01-service-account"
  node_account_name    = "kube-01-node-account"

  # Zonal
  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9bntituqauouau4bek3"
    }
  ]

  kms_key = {
    name = "kube01-kms-key"
  }

  master_labels = {
    environment = "testing"
    owner       = "yandex"
    role        = "master"
    service     = "kubernetes"
  }

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01"
      auto_scale = {
        min     = 2
        max     = 4
        initial = 2
      }
      node_labels = {
        role        = "worker-01"
        environment = "testing"
      }
    },
    "yc-k8s-ng-02" = {
      version     = "1.25"
      description = "Kubernetes nodes group 02"
      auto_scale = {
        min     = 3
        max     = 5
        initial = 3
      }
      node_labels = {
        role        = "worker-02"
        environment = "testing"
      }
      max_expansion   = 2
      max_unavailable = 2
    },
    "yc-k8s-ng-03" = {
      description = "Kubernetes nodes group 03"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      node_labels = {
        role        = "worker-03"
        environment = "testing"
      }
      max_expansion   = 1
      max_unavailable = 1
    }
  }

  # Custom ingress / egress rules
  custom_ingress_rules = {
    "rule1" = {
      protocol       = "TCP"
      description    = "rule-1"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 8443
    },
    "rule2" = {
      protocol       = "TCP"
      description    = "rule-2"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    }
  }

  custom_egress_rules = {
    "rule1" = {
      protocol       = "ANY"
      description    = "rule-1"
      v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      from_port      = 8190
      to_port        = 8199
    },
    "rule2" = {
      protocol       = "UDP"
      description    = "rule-2"
      v4_cidr_blocks = ["10.0.3.0/24"]
      from_port      = 8190
      to_port        = 8199
    }
  }
}

module "kube_02" {
  source = "../../"

  cluster_name         = "kube-cluster-02"
  cluster_version      = "1.28"
  release_channel      = "REGULAR"
  folder_id            = "b1g4cr5d305a2bsm2im0"
  network_id           = "enpv53lp27m52o0be8lj"
  public_access        = true
  create_kms           = true
  enable_cilium_policy = true
  cluster_ipv4_range   = "172.19.0.0/16"
  service_ipv4_range   = "172.20.0.0/16"
  service_account_name = "kube-02-service-account"
  node_account_name    = "kube-02-node-account"

  # Regional
  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9bntituqauouau4bek3"
    },
    {
      zone      = "ru-central1-b"
      subnet_id = "e2l4uju9nsorr7jhcegu"
    },
    {
      zone      = "ru-central1-d"
      subnet_id = "fl8788ou1fs1111epdc4"
    }
  ]

  kms_key = {
    name = "kube02-kms-key"
  }

  master_labels = {
    environment = "testing"
    owner       = "example"
    role        = "master"
    service     = "kubernetes"
  }

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "20:00"
      duration   = "3h"
    },
    {
      day        = "wednesday"
      start_time = "10:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "kube-02-ng-01" = {
      description = "Kubernetes 02 nodes group 01"
      node_memory = 4
      node_cores  = 4
      fixed_scale = {
        size = 3
      }
      node_labels = {
        role        = "worker-02"
        environment = "testing"
      }
      max_expansion   = 2
      max_unavailable = 2
    },
    "kube-02-ng-02" = {
      description = "Kubernetes 02 nodes group 02"
      node_memory = 4
      node_cores  = 4
      auto_scale = {
        min     = 2
        max     = 4
        initial = 2
      }
      node_labels = {
        role        = "worker-02"
        environment = "testing"
      }
      max_expansion   = 2
      max_unavailable = 2
    },
    "yc-k8s-ng-031" = {
      description = "Kubernetes nodes group 031"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      node_labels = {
        role        = "worker-031"
        environment = "testing"
      }
    },
    "yc-k8s-ng-041" = {
      description = "Kubernetes nodes group 041"
      auto_scale = {
        min     = 1
        max     = 2
        initial = 2
      }
      node_labels = {
        role        = "worker-041"
        environment = "testing"
      }
      max_expansion   = 1
      max_unavailable = 1
    }
  }

  # Custom ingress /egress rules
  custom_ingress_rules = {
    "rule1" = {
      protocol       = "TCP"
      description    = "rule-1"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 8080
    },
    "rule2" = {
      protocol       = "TCP"
      description    = "rule-2"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    }
  }

  custom_egress_rules = {
    "rule1" = {
      protocol       = "ANY"
      description    = "rule-1"
      v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      from_port      = 8090
      to_port        = 8099
    },
    "rule2" = {
      protocol       = "UDP"
      description    = "rule-2"
      v4_cidr_blocks = ["10.0.1.0/24"]
      from_port      = 8090
      to_port        = 8099
    }
  }
}
