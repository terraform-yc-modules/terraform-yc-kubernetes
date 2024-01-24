# Security groups
resource "yandex_vpc_security_group" "k8s_main_sg" {
  count       = var.enable_default_rules ? 1 : 0
  folder_id   = local.folder_id
  name        = "k8s-security-main-${random_string.unique_id.result}"
  description = "K8S security group"
  network_id  = var.network_id

  ingress {
    protocol          = "TCP"
    description       = "Rule allows availability checks from load balancer's address range. It is required for the operation of a fault-tolerant cluster and load balancer services."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ANY"
    description       = "Rule allows master-node and node-node communication inside a security group."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol       = "ANY"
    description    = "Rule allows pod-pod and service-service communication inside a security group. Indicate your IP ranges."
    v4_cidr_blocks = [var.cluster_ipv4_range, var.service_ipv4_range]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "ICMP"
    description    = "Rule allows debugging ICMP packets from internal subnets."
    v4_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
}

resource "yandex_vpc_security_group" "k8s_master_whitelist_sg" {
  count       = var.enable_default_rules ? 1 : 0
  folder_id   = local.folder_id
  name        = "k8s-master-whitelist-${random_string.unique_id.result}"
  description = "Allow access to Kubernetes API from internet."
  network_id  = var.network_id

  ingress {
    protocol       = "TCP"
    description    = "Allow access to Kubernetes API via port 6443 from subnet."
    v4_cidr_blocks = var.allowed_ips
    port           = 6443
  }
  ingress {
    protocol       = "TCP"
    description    = "Allow access to Kubernetes API via port 443 from subnet."
    v4_cidr_blocks = var.allowed_ips
    port           = 443
  }
}

resource "yandex_vpc_security_group" "k8s_nodes_ssh_access_sg" {
  count       = var.enable_default_rules ? 1 : 0
  folder_id   = local.folder_id
  name        = "k8s-nodes-ssh-access-${random_string.unique_id.result}"
  description = "Allow connect to workers nodes from internet SSH."
  network_id  = var.network_id

  ingress {
    protocol       = "TCP"
    description    = "Allow access to worker nodes via SSH from IP's."
    v4_cidr_blocks = var.allowed_ips_ssh
    port           = 22
  }
}

# This group defines custom security rules
resource "yandex_vpc_security_group" "k8s_custom_rules_sg" {
  count       = length(var.custom_ingress_rules) > 0 || length(var.custom_egress_rules) > 0 ? 1 : 0
  folder_id   = local.folder_id
  name        = "k8s-custom-rules-group-${random_string.unique_id.result}"
  description = "This group defines custom ingress / egress security rules."
  network_id  = var.network_id
}

resource "yandex_vpc_security_group_rule" "ingress_rules" {
  for_each = var.custom_ingress_rules

  security_group_binding = yandex_vpc_security_group.k8s_custom_rules_sg[0].id
  direction              = "ingress"
  description            = lookup(each.value, "description", null)
  v4_cidr_blocks         = lookup(each.value, "v4_cidr_blocks", [])
  from_port              = lookup(each.value, "from_port", null)
  to_port                = lookup(each.value, "to_port", null)
  port                   = lookup(each.value, "port", null)
  protocol               = lookup(each.value, "protocol", "TCP")
}

resource "yandex_vpc_security_group_rule" "egress_rules" {
  for_each = var.custom_egress_rules

  security_group_binding = yandex_vpc_security_group.k8s_custom_rules_sg[0].id
  direction              = "egress"
  description            = lookup(each.value, "description", null)
  v4_cidr_blocks         = lookup(each.value, "v4_cidr_blocks", [])
  from_port              = lookup(each.value, "from_port", null)
  to_port                = lookup(each.value, "to_port", null)
  port                   = lookup(each.value, "port", null)
  protocol               = lookup(each.value, "protocol", "TCP")
}
