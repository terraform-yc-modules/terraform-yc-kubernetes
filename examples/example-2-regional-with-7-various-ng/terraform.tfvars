network_id              = "enpneopbt180nusgut3q"
cluster_name            = "kube-regional-cluster"
description             = "Kubernetes test cluster"
cluster_version         = "1.27"
public_access           = true
create_kms              = true
cluster_ipv4_range      = "172.17.0.0/16"
service_ipv4_range      = "172.18.0.0/16"
release_channel         = "STABLE"
enable_cilium_policy    = false
network_policy_provider = "CALICO"
service_account_name    = "k8s-ex2-service-account"
node_account_name       = "k8s-ex2-node-account"

kms_key = {
  name = "k8s-kms-key"
}

master_maintenance_windows = [
  {
    day        = "monday"
    start_time = "23:00"
    duration   = "3h"
  }
]

master_labels = {
  role        = "master"
  environment = "testing"
  owner       = "example"
  service     = "kubernetes"
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
