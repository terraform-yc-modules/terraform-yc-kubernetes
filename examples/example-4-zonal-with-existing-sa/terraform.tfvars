
cluster_name         = "kube-regional-cluster"
cluster_version      = "1.27"
description          = "Kubernetes test cluster"
public_access        = true
create_kms           = true
enable_cilium_policy = true

use_existing_sa           = true
master_service_account_id = "3iuebyrv7trcsftf3d23"
node_service_account_id   = "nfhyby47hfnrsmjgt5fs"

kms_key = {
  name = "kube-regional-kms-key"
}

master_labels = {
  environment = "dev"
  owner       = "example"
  role        = "master"
  service     = "kubernetes"
}
