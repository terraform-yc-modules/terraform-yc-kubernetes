
cluster_name         = "kube-regional-cluster"
cluster_version      = "1.23"
description          = "Kubernetes test cluster"
public_access        = true
create_kms           = true
enable_cilium_policy = true

kms_key = {
  name = "kube-regional-kms-key"
}

master_labels = {
  environment = "dev"
  owner       = "example"
  role        = "master"
  service     = "kubernetes"
}
