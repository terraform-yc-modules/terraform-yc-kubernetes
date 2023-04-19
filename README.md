# Kubernetes Terraform Module for Yandex Cloud

## Features

- Create Kubernetes cluster of two types: zonal or regional 
- Create user defined Kubernetes node groups
- Create service accounts and KMS encryption key for Kubernetes cluster
- Easy to use in other resources via outputs

## Kubernetes cluster definition

First, you need to create a VPC network with three subnets.

The Kubernetes module requires the following input variables:
 - VPC network ID
 - VPC network subnet IDs
 - Master locations: List of maps with zone names and subnet IDs for each location
 - Node groups: List of node group maps with any number of parameters

> Master locations may only have either one or three locations: one for zonal cluster and three for regional cluster.

<b>Notes:</b>
  - If the node group version is missing, `cluster version` will be used instead.
  - All node groups are able to define their own locations. These locations will be used instead of master locations.
  - If an own location was not defined for a node group with the `auto scale` policy, the location for this group will be automatically generated from the master location list.
  - If the node group list has more than three groups, the locations for them will be assigned from the beginning of the master location list. This means all node groups will be distributed in the range of the master location list.
  - All three master locations will be used for the `fixed scale` node groups.

## Node Group definition

The `node_groups` section defines a list of maps for each node group. You can determine any parameter for each node group, but all of them have default values. This way, an empty node group object will be created using such default values.
For instance, in `example 2`, we define seven node groups with their own parameters. You can create any number of node groups, which is only limited by the Yandex Kubernetes service capacity. If the `node_location` parameter is not provided, the location will be automatically assigned from the master location list. 

```
node_groups = {
  "yc-k8s-ng-01" = {
    description  = "Kubernetes nodes group 01"
    fixed_scale  = {
      size       = 2
    }
  },
  "yc-k8s-ng-02" = {
    description   = "Kubernetes nodes group 02"
    auto_scale    = {
      min         = 3
      max         = 5
      initial     = 3
    }
  }
}

```

### Example Usage

```hcl-terraform
module "kube" {
  source     = "./modules/kubernetes"
  network_id = "enpmff6ah2bvi0k10j66"

  master_locations   = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9b3k97pr2nh1i80as04"
    },
    {
      zone      = "ru-central1-b" 
      subnet_id = "e2laaglsc7u99ur8c4j1"
    },
    {
      zone      = "ru-central1-c" 
      subnet_id = "b0ckjm3olbpmk2t6c28o"
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      description  = "Kubernetes nodes group 01"
      fixed_scale   = {
        size = 3
      }
      node_labels   = {
        role        = "worker-01"
        environment = "testing"
      }
    },
    "yc-k8s-ng-02"  = {
      description   = "Kubernetes nodes group 02"
      auto_scale    = {
        min         = 2
        max         = 4
        initial     = 2
      }
      node_locations   = [
        {
          zone      = "ru-central1-b"
          subnet_id = "e2lu07tr481h35012c8p"
        }
      ]
      node_labels   = {
        role        = "worker-02"
        environment = "dev"
      }
      max_expansion   = 1
      max_unavailable = 1
    }
  }
}
```

## Configuring Terraform for Yandex Cloud

- Install [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
- Add environment variables for `terraform auth` in Yandex Cloud:

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.0.0 or higher|
| <a name="requirement_random"></a> [random](#requirement\_random) | Higher than 3.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | Higher than 0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | Higher than 3.3 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.86.0 |

## Modules

There are no modules available.

## Resources

| Name | Type |
|------|------|
| [random_string.unique_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | Resource |
| [yandex_iam_service_account.master](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | Resource |
| [yandex_iam_service_account.node_account](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | Resource |
| [yandex_kms_symmetric_key.kms_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | Resource |
| [yandex_kms_symmetric_key_iam_binding.encrypter_decrypter](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key_iam_binding) | Resource |
| [yandex_kubernetes_cluster.kube_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) | resource |
| [yandex_kubernetes_node_group.kube_node_groups](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group) | Resource |
| [yandex_resourcemanager_folder_iam_member.node_account](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | Resource |
| [yandex_resourcemanager_folder_iam_member.sa_calico_network_policy_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | Resource |
| [yandex_resourcemanager_folder_iam_member.sa_cilium_network_policy_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | Resource |
| [yandex_resourcemanager_folder_iam_member.sa_node_group_loadbalancer_role_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | Resource |
| [yandex_resourcemanager_folder_iam_member.sa_node_group_public_role_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | Resource |
| [yandex_resourcemanager_folder_iam_member.sa_public_loadbalancers_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | Resource |
| [yandex_vpc_security_group.k8s_custom_rules_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | Resource |
| [yandex_vpc_security_group.k8s_main_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | Resource |
| [yandex_vpc_security_group.k8s_master_whitelist_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | Resource |
| [yandex_vpc_security_group.k8s_nodes_ssh_access_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | Resource |
| [yandex_vpc_security_group_rule.egress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | Resource |
| [yandex_vpc_security_group_rule.ingress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | Resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | Data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_load_balancers"></a> [allow\_public\_load\_balancers](#input\_allow\_public\_load\_balancers) | Flag for creating new IAM role with a `load-balancer.admin` access. | `bool` | `true` | No |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of allowed IPv4 CIDR blocks. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | No |
| <a name="input_allowed_ips_ssh"></a> [allowed\_ips\_ssh](#input\_allowed\_ips\_ssh) | List of allowed IPv4 CIDR blocks for an access via SSH. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | No |
| <a name="input_cluster_ipv4_range"></a> [cluster\_ipv4\_range](#input\_cluster\_ipv4\_range) | CIDR block that provides an IP range for allocating pod addresses.<br>It must not overlap with any subnet in the network the Kubernetes cluster is located in.<br>Static routes will be set up for this CIDR blocks in node subnets. | `string` | `"172.17.0.0/16"` | No |
| <a name="input_cluster_ipv6_range"></a> [cluster\_ipv6\_range](#input\_cluster\_ipv6\_range) | IPv6 CIDR block that provides an IP range for allocating pod addresses. | `string` | `null` | No |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of a specific Kubernetes cluster. | `string` | `"k8s-cluster"` | No |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes cluster version | `string` | `"1.23"` | No |
| <a name="input_container_runtime_type"></a> [container\_runtime\_type](#input\_container\_runtime\_type) | Runtime type of Kubernetes node group container | `string` | `"containerd"` | No |
| <a name="input_create_kms"></a> [create\_kms](#input\_create\_kms) | Flag for enabling or disabling KMS key creation | `bool` | `true` | No |
| <a name="input_custom_egress_rules"></a> [custom\_egress\_rules](#input\_custom\_egress\_rules) | Map definition of custom security egress rules.<br><br>Example:<pre>custom_egress_rules = {<br>  "rule1" = {<br>    protocol       = "ANY"<br>    description    = "rule-1"<br>    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]<br>    from_port      = 8090<br>    to_port        = 8099<br>  },<br>  "rule2" = {<br>    protocol       = "UDP"<br>    description    = "rule-2"<br>    v4_cidr_blocks = ["10.0.1.0/24"]<br>    from_port      = 8090<br>    to_port        = 8099<br>  }<br>}</pre> | `any` | `{}` | No |
| <a name="input_custom_ingress_rules"></a> [custom\_ingress\_rules](#input\_custom\_ingress\_rules) | Map definition of custom security ingress rules.<br><br>Example:<pre>custom_ingress_rules = {<br>  "rule1" = {<br>    protocol = "TCP"<br>    description = "rule-1"<br>    v4_cidr_blocks = ["0.0.0.0/0"]<br>    from_port = 3000<br>    to_port = 32767<br>  },<br>  "rule2" = {<br>    protocol = "TCP"<br>    description = "rule-2"<br>    v4_cidr_blocks = ["0.0.0.0/0"]<br>    port = 443<br>  },<br>  "rule3" = {<br>    protocol = "TCP"<br>    description = "rule-3"<br>    predefined_target = "self_security_group"<br>    from_port         = 0<br>    to_port           = 65535<br>  }<br>}</pre> | `any` | `{}` | No |
| <a name="input_description"></a> [description](#input\_description) | Description of the Kubernetes cluster. | `string` | `"Yandex Managed K8S cluster"` | No |
| <a name="input_enable_cilium_policy"></a> [enable\_cilium\_policy](#input\_enable\_cilium\_policy) | Flag for enabling or disabling Cilium CNI. | `bool` | `false` | No |
| <a name="input_enable_default_rules"></a> [enable\_default\_rules](#input\_enable\_default\_rules) | Manages creation of default security rules.<br><br>Default security rules:<br> - Allow all incoming traffic from any protocol.<br> - Allow master-to-node and node-to-node communication inside a security group.<br> - Allow pod-to-pod and service-to-service communication.<br> - Allow debugging ICMP packets from internal subnets.<br> - Allow incoming traffic from the web to the `NodePort` port range.<br> - Allow all outgoing traffic. Nodes can connect to Yandex Container Registry, Yandex Object Storage, Docker Hub, etc.<br> - Allow access to Kubernetes API via port 6443 from the subnet.<br> - Allow access to Kubernetes API via port 443 from the subnet.<br> - Allow access to worker nodes via SSH from the allowed IP range. | `bool` | `true` | No |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID of the folder the Kubernetes cluster belongs to | `string` | `null` | No |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | KMS symmetric key parameters | `any` | `{}` | No |
| <a name="input_master_auto_upgrade"></a> [master\_auto\_upgrade](#input\_master\_auto\_upgrade) | Boolean flag that specifies whether master can be upgraded automatically | `bool` | `true` | No |
| <a name="input_master_labels"></a> [master\_labels](#input\_master\_labels) | Set of key/value label pairs to assign Kubernetes master nodes to. | `map(string)` | `{}` | No |
| <a name="input_master_locations"></a> [master\_locations](#input\_master\_locations) | List of locations where the cluster will be created.<br>If the list contains only one location, a zonal cluster will be created; if there are three locations, this will create a regional cluster.<br>Note: The master location list may only have either one or three locations. | <pre>list(object({<br>    zone      = string<br>    subnet_id = string<br>  }))</pre> | N/A | Yes |
| <a name="input_master_logging"></a> [master\_logging](#input\_master\_logging) | (Optional) Master logging options | `map` | <pre>{<br>  "enabled": true,<br>  "enabled_autoscaler": true,<br>  "enabled_events": true,<br>  "enabled_kube_apiserver": true,<br>  "folder_id": null<br>}</pre> | No |
| <a name="input_master_maintenance_windows"></a> [master\_maintenance\_windows](#input\_master\_maintenance\_windows) | List of structures that specifies maintenance windows,<br>when auto update for the master is allowed.<br><br>    Example:<pre>master_maintenance_windows = [<br>      {<br>        day        = "monday"<br>        start_time = "23:00"<br>        duration   = "3h"<br>      }<br>    ]</pre> | `list(map(string))` | `[]` | No |
| <a name="input_master_region"></a> [master\_region](#input\_master\_region) | Name of the region where the cluster will be created. This setting is required for regional clusters and not used for zonal clusters. | `string` | `"ru-central1"` | No |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | Network acceleration type for the Kubernetes node group | `string` | `"standard"` | No |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | ID of the cluster network | `string` | N/A | Yes |
| <a name="input_network_policy_provider"></a> [network\_policy\_provider](#input\_network\_policy\_provider) | Network policy provider for Kubernetes cluster | `string` | `"CALICO"` | No |
| <a name="input_node_account_name"></a> [node\_account\_name](#input\_node\_account\_name) | IAM node account name | `string` | `"k8s-node-account"` | No |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Map of maps for Kubernetes node groups. It may contain all parameters of the `yandex\_kubernetes\_node\_group` resource, many of which may be null and have default values.<br><br>Notes:<br>     - If the node group version is not specified, the cluster version will be used instead.<br>     - Master location list may only have one location for a zonal cluster and three locations for a regional one.<br>     - All node groups are able to define their own locations. These locations will be used first.<br>     - If own locations are not defined for node groups with the `auto scale` policy, the locations for these groups will be automatically generated from master locations. If a node group list has more than three groups, the locations for them will be assigned from the beginning of the master location list. This means all node groups will be distributed in the range of the master locations. <br>     - Master locations will be used for fixed scale node groups.<br>     - Auto repair and upgrade values will be used for the `master\_auto\_upgrade value`.<br>     - Master maintenance windows will also be used for Node groups.<br>     - You can specify only one `max\_expansion` or `max\_unavailable` value for the deployment policy.<br><br>You can find more information on node groups in the [Terraform provider documentation](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).<br><br>    Default values:<pre>platform_id     = "standard-v3"<br>      node_cores      = 4<br>      node_memory     = 8<br>      node_gpus       = 0<br>      core_fraction   = 100<br>      disk_type       = "network-ssd"<br>      disk_size       = 32<br>      preemptible     = false<br>      nat             = false<br>      auto_repair     = true<br>      auto_upgrade    = true<br>      maintenance_day           = "monday"<br>      maintenance_start_time    = "20:00"<br>      maintenance_duration      = "3h30m"<br>      network_acceleration_type = "standard"<br>      container_runtime_type    = "containerd"</pre>Example:<pre>node_groups = {<br>        "yc-k8s-ng-01"  = {<br>          cluster_name  = "k8s-kube-cluster"<br>          description   = "Kubernetes nodes group with fixed scale policy and one maintenance window"<br>          fixed_scale   = {<br>            size = 3<br>          }<br>          labels        = {<br>            owner       = "yandex"<br>            service     = "kubernetes"<br>          }<br>          node_labels   = {<br>            role        = "worker-01"<br>            environment = "dev"<br>          }<br>        },<br>        "yc-k8s-ng-02"  = {<br>          description   = "Kubernetes nodes group with auto scale policy"<br>          auto_scale    = {<br>            min         = 2<br>            max         = 4<br>            initial     = 2<br>          }<br>          node_locations   = [<br>            {<br>              zone      = "ru-central1-b"<br>              subnet_id = "e2lu07tr481h35012c8p"<br>            }<br>          ]<br>          labels        = {<br>            owner       = "example"<br>            service     = "kubernetes"<br>          }<br>          node_labels   = {<br>            role        = "worker-02"<br>            environment = "testing"<br>          }<br>        }<br>      }</pre> | `any` | `{}` | No |
| <a name="input_node_groups_defaults"></a> [node\_groups\_defaults](#input\_node\_groups\_defaults) | Map of common default values for Node groups | `map` | <pre>{<br>  "core_fraction": 100,<br>  "disk_size": 32,<br>  "disk_type": "network-ssd",<br>  "ipv4": true,<br>  "ipv6": false,<br>  "nat": false,<br>  "node_cores": 4,<br>  "node_gpus": 0,<br>  "node_memory": 8,<br>  "platform_id": "standard-v3",<br>  "preemptible": false<br>}</pre> | No |
| <a name="input_node_ipv4_cidr_mask_size"></a> [node\_ipv4\_cidr\_mask\_size](#input\_node\_ipv4\_cidr\_mask\_size) | (Optional) Size of the masks assigned to each node in the cluster.<br>This efficiently limits the maximum number of pods for each node. | `number` | `24` | No |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Public or private Kubernetes cluster | `bool` | `true` | No |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | Kubernetes cluster release channel name | `string` | `"REGULAR"` | No |
| <a name="input_security_groups_ids_list"></a> [security\_groups\_ids\_list](#input\_security\_groups\_ids\_list) | List of security group IDs the Kubernetes cluster belongs to | `list(string)` | `[]` | No |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | IAM service account name | `string` | `"k8s-service-account"` | No |
| <a name="input_service_ipv4_range"></a> [service\_ipv4\_range](#input\_service\_ipv4\_range) | CIDR block that provides an IP range from which Kubernetes service cluster IP addresses will be allocated.<br>It should not overlap with any subnet in the network the Kubernetes cluster is located in. | `string` | `"172.18.0.0/16"` | No |
| <a name="input_service_ipv6_range"></a> [service\_ipv6\_range](#input\_service\_ipv6\_range) | IPv6 CIDR block that provides an IP range for allocating pod addresses | `string` | `null` | No |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeouts | `map(string)` | <pre>{<br>  "create": "60m",<br>  "delete": "60m",<br>  "update": "60m"<br>}</pre> | No |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Kubernetes cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes cluster name |
| <a name="output_external_cluster_cmd"></a> [external\_cluster\_cmd](#output\_external\_cluster\_cmd) | Kubernetes cluster public IP address.<br>Use the following command to download kube config and start working with Yandex Managed Kubernetes Cluster:<br>`$ yc managed-kubernetes cluster get-credentials --id <cluster\_id> --external`<br>This command will automatically add kube config for your user; after that, you will be able to test it with the `<kubectl get cluster-info>` command. |
| <a name="output_internal_cluster_cmd"></a> [internal\_cluster\_cmd](#output\_internal\_cluster\_cmd) | Kubernetes cluster private IP address.<br>Use the following command to download kube config and start working with Yandex Managed Kubernetes Cluster:<br>`$ yc managed-kubernetes cluster get-credentials --id <cluster\_id> --internal`<br>Note: Kubernetes internal cluster nodes are available from the nodes in the same subnet as cluster nodes. |
<!-- END_TF_DOCS -->
