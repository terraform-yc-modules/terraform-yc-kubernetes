# Kubernetes Terraform Module for Yandex.Cloud

## Features

- Create Kubernetes cluster of two types: zonal or regional 
- Create user defined Kubernetes node groups
- Create service accounts and KMS encryption key for Kubernetes cluster
- Easy to use in other resources via outputs

## Kubernetes cluster definition

First, you need to create a VPC network with three subnets!

The Kubernetes module requires the following input variables:
 - VPC network ID
 - VPC network subnet IDs
 - Master locations: List of maps with zone names and subnet IDs for each location.
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

## Configure Terraform for Yandex Cloud

- Install [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
- Add environment variables for terraform authentication in Yandex Cloud

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | > 3.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | > 0.9 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | > 0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.1 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.98.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_string.unique_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.wait_for_iam](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [yandex_iam_service_account.master](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account.node_account](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_kms_symmetric_key.kms_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | resource |
| [yandex_kms_symmetric_key_iam_binding.encrypter_decrypter](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key_iam_binding) | resource |
| [yandex_kms_symmetric_key_iam_binding.encrypter_decrypter_existing_sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key_iam_binding) | resource |
| [yandex_kubernetes_cluster.kube_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) | resource |
| [yandex_kubernetes_node_group.kube_node_groups](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group) | resource |
| [yandex_resourcemanager_folder_iam_member.node_account](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_calico_network_policy_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_cilium_network_policy_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_logging_writer_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_node_group_loadbalancer_role_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_node_group_public_role_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_public_loadbalancers_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_vpc_security_group.k8s_custom_rules_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.k8s_main_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.k8s_master_whitelist_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.k8s_nodes_ssh_access_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group_rule.egress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_load_balancers"></a> [allow\_public\_load\_balancers](#input\_allow\_public\_load\_balancers) | Flag for creating new IAM role with a load-balancer.admin access. | `bool` | `true` | no |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of allowed IPv4 CIDR blocks. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_allowed_ips_ssh"></a> [allowed\_ips\_ssh](#input\_allowed\_ips\_ssh) | List of allowed IPv4 CIDR blocks for an access via SSH. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_ipv4_range"></a> [cluster\_ipv4\_range](#input\_cluster\_ipv4\_range) | CIDR block. IP range for allocating pod addresses.<br>  It should not overlap with any subnet in the network<br>  the Kubernetes cluster located in. Static routes will<br>  be set up for this CIDR blocks in node subnets. | `string` | `"172.17.0.0/16"` | no |
| <a name="input_cluster_ipv6_range"></a> [cluster\_ipv6\_range](#input\_cluster\_ipv6\_range) | IPv6 CIDR block. IP range for allocating pod addresses. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of a specific Kubernetes cluster. | `string` | `"k8s-cluster"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes cluster version | `string` | `null` | no |
| <a name="input_container_runtime_type"></a> [container\_runtime\_type](#input\_container\_runtime\_type) | Kubernetes Node Group container runtime type | `string` | `"containerd"` | no |
| <a name="input_create_kms"></a> [create\_kms](#input\_create\_kms) | Flag for enabling or disabling KMS key creation. | `bool` | `true` | no |
| <a name="input_custom_egress_rules"></a> [custom\_egress\_rules](#input\_custom\_egress\_rules) | Map definition of custom security egress rules.<br><br>Example:<pre>custom_egress_rules = {<br>  "rule1" = {<br>    protocol       = "ANY"<br>    description    = "rule-1"<br>    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]<br>    from_port      = 8090<br>    to_port        = 8099<br>  },<br>  "rule2" = {<br>    protocol       = "UDP"<br>    description    = "rule-2"<br>    v4_cidr_blocks = ["10.0.1.0/24"]<br>    from_port      = 8090<br>    to_port        = 8099<br>  }<br>}</pre> | `any` | `{}` | no |
| <a name="input_custom_ingress_rules"></a> [custom\_ingress\_rules](#input\_custom\_ingress\_rules) | Map definition of custom security ingress rules.<br><br>Example:<pre>custom_ingress_rules = {<br>  "rule1" = {<br>    protocol = "TCP"<br>    description = "rule-1"<br>    v4_cidr_blocks = ["0.0.0.0/0"]<br>    from_port = 3000<br>    to_port = 32767<br>  },<br>  "rule2" = {<br>    protocol = "TCP"<br>    description = "rule-2"<br>    v4_cidr_blocks = ["0.0.0.0/0"]<br>    port = 443<br>  },<br>  "rule3" = {<br>    protocol = "TCP"<br>    description = "rule-3"<br>    predefined_target = "self_security_group"<br>    from_port         = 0<br>    to_port           = 65535<br>  }<br>}</pre> | `any` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Kubernetes cluster. | `string` | `"Yandex Managed K8S cluster"` | no |
| <a name="input_enable_cilium_policy"></a> [enable\_cilium\_policy](#input\_enable\_cilium\_policy) | Flag for enabling or disabling Cilium CNI. | `bool` | `false` | no |
| <a name="input_enable_default_rules"></a> [enable\_default\_rules](#input\_enable\_default\_rules) | Manages creation of default security rules.<br><br>Default security rules:<br> - Allow all incoming traffic from any protocol.<br> - Allows master-to-node and node-to-node communication inside a security group.<br> - Allows pod-to-pod and service-to-service communication.<br> - Allows debugging ICMP packets from internal subnets.<br> - Allows incomming traffic from the Internet to the NodePort port range.<br> - Allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Yandex Object Storage, Docker Hub, etc.<br> - Allow access to Kubernetes API via port 6443 from the subnet.<br> - Allow access to Kubernetes API via port 443 from the subnet.<br> - Allow access to worker nodes via SSH from the allowed IP range. | `bool` | `true` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of the folder that the Kubernetes cluster belongs to. | `string` | `null` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | KMS symmetric key parameters. | `any` | `{}` | no |
| <a name="input_master_auto_upgrade"></a> [master\_auto\_upgrade](#input\_master\_auto\_upgrade) | Boolean flag that specifies if master can be upgraded automatically. | `bool` | `true` | no |
| <a name="input_master_labels"></a> [master\_labels](#input\_master\_labels) | Set of key/value label pairs to assign Kubernetes master nodes. | `map(string)` | `{}` | no |
| <a name="input_master_locations"></a> [master\_locations](#input\_master\_locations) | List of locations where the cluster will be created. If the list contains only one<br>location, a zonal cluster will be created; if there are three locations, this will create a regional cluster.<br><br>Note: The master locations list may only have ONE or THREE locations. | <pre>list(object({<br>    zone      = string<br>    subnet_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_master_logging"></a> [master\_logging](#input\_master\_logging) | (Optional) Master logging options. | `map(any)` | <pre>{<br>  "enabled": true,<br>  "enabled_autoscaler": true,<br>  "enabled_events": true,<br>  "enabled_kube_apiserver": true,<br>  "folder_id": null<br>}</pre> | no |
| <a name="input_master_maintenance_windows"></a> [master\_maintenance\_windows](#input\_master\_maintenance\_windows) | List of structures that specifies maintenance windows,<br>    when auto update for the master is allowed.<br><br>    Example:<pre>master_maintenance_windows = [<br>      {<br>        day        = "monday"<br>        start_time = "23:00"<br>        duration   = "3h"<br>      }<br>    ]</pre> | `list(map(string))` | `[]` | no |
| <a name="input_master_region"></a> [master\_region](#input\_master\_region) | Name of the region where the cluster will be created. This setting is required for regional cluster and not used for zonal cluster. | `string` | `"ru-central1"` | no |
| <a name="input_master_service_account_id"></a> [master\_service\_account\_id](#input\_master\_service\_account\_id) | Existing service account ID for control plane. | `string` | `null` | no |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | Network acceleration type for the Kubernetes node group | `string` | `"standard"` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The ID of the cluster network. | `string` | n/a | yes |
| <a name="input_network_policy_provider"></a> [network\_policy\_provider](#input\_network\_policy\_provider) | Network policy provider for Kubernetes cluster | `string` | `"CALICO"` | no |
| <a name="input_node_account_name"></a> [node\_account\_name](#input\_node\_account\_name) | IAM node account name. | `string` | `"k8s-node-account"` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Kubernetes node groups map of maps. It could contain all parameters of yandex\_kubernetes\_node\_group resource,<br>    many of them could be NULL and have default values.<br><br>    Notes:<br>     - If node groups version isn't defined, cluster version will be used instead of.<br>     - A master locations list must have only one location for zonal cluster and three locations for a regional.<br>     - All node groups are able to define own locations. These locations will be used at first.<br>     - If own location aren't defined for node groups with auto scale policy, locations for these groups will be automatically generated from master locations. If node groups list have more than three groups, locations for them will be assigned from the beggining of the master locations list. So, all node groups will be distributed in a range of master locations. <br>     - Master locations will be used for fixed scale node groups.<br>     - Auto repair and upgrade values will be used master\_auto\_upgrade value.<br>     - Master maintenance windows will be used for Node groups also!<br>     - Only one max\_expansion OR max\_unavailable values should be specified for the deployment policy.<br><br>    Documentation - https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group<br><br>    Default values:<pre>platform_id     = "standard-v3"<br>      node_cores      = 4<br>      node_memory     = 8<br>      node_gpus       = 0<br>      core_fraction   = 100<br>      disk_type       = "network-ssd"<br>      disk_size       = 32<br>      preemptible     = false<br>      nat             = false<br>      auto_repair     = true<br>      auto_upgrade    = true<br>      maintenance_day           = "monday"<br>      maintenance_start_time    = "20:00"<br>      maintenance_duration      = "3h30m"<br>      network_acceleration_type = "standard"<br>      container_runtime_type    = "containerd"</pre>Example:<pre>node_groups = {<br>        "yc-k8s-ng-01"  = {<br>          cluster_name  = "k8s-kube-cluster"<br>          description   = "Kubernetes nodes group with fixed scale policy and one maintenance window"<br>          fixed_scale   = {<br>            size = 3<br>          }<br>          labels        = {<br>            owner       = "yandex"<br>            service     = "kubernetes"<br>          }<br>          node_labels   = {<br>            role        = "worker-01"<br>            environment = "dev"<br>          }<br>        },<br>        "yc-k8s-ng-02"  = {<br>          description   = "Kubernetes nodes group with auto scale policy"<br>          auto_scale    = {<br>            min         = 2<br>            max         = 4<br>            initial     = 2<br>          }<br>          node_locations   = [<br>            {<br>              zone      = "ru-central1-b"<br>              subnet_id = "e2lu07tr481h35012c8p"<br>            }<br>          ]<br>          labels        = {<br>            owner       = "example"<br>            service     = "kubernetes"<br>          }<br>          node_labels   = {<br>            role        = "worker-02"<br>            environment = "testing"<br>          }<br>        }<br>      }</pre> | `any` | `{}` | no |
| <a name="input_node_groups_defaults"></a> [node\_groups\_defaults](#input\_node\_groups\_defaults) | Map of common default values for Node groups. | `map(any)` | <pre>{<br>  "core_fraction": 100,<br>  "disk_size": 32,<br>  "disk_type": "network-ssd",<br>  "ipv4": true,<br>  "ipv6": false,<br>  "nat": false,<br>  "node_cores": 4,<br>  "node_gpus": 0,<br>  "node_memory": 8,<br>  "platform_id": "standard-v3",<br>  "preemptible": false<br>}</pre> | no |
| <a name="input_node_ipv4_cidr_mask_size"></a> [node\_ipv4\_cidr\_mask\_size](#input\_node\_ipv4\_cidr\_mask\_size) | (Optional) Size of the masks that are assigned to each node in the cluster.<br>    This efficiently limits the maximum number of pods for each node. | `number` | `24` | no |
| <a name="input_node_service_account_id"></a> [node\_service\_account\_id](#input\_node\_service\_account\_id) | Existing service account ID for worker nodes. | `string` | `null` | no |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Public or private Kubernetes cluster | `bool` | `true` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | Kubernetes cluster release channel name | `string` | `"REGULAR"` | no |
| <a name="input_security_groups_ids_list"></a> [security\_groups\_ids\_list](#input\_security\_groups\_ids\_list) | List of security group IDs to which the Kubernetes cluster belongs | `list(string)` | `[]` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | IAM service account name. | `string` | `"k8s-service-account"` | no |
| <a name="input_service_ipv4_range"></a> [service\_ipv4\_range](#input\_service\_ipv4\_range) | CIDR block. IP range from which Kubernetes service cluster IP addresses <br>    will be allocated from. It should not overlap with<br>    any subnet in the network the Kubernetes cluster located in | `string` | `"172.18.0.0/16"` | no |
| <a name="input_service_ipv6_range"></a> [service\_ipv6\_range](#input\_service\_ipv6\_range) | IPv6 CIDR block. IP range for allocating pod addresses. | `string` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeouts. | `map(string)` | <pre>{<br>  "create": "60m",<br>  "delete": "60m",<br>  "update": "60m"<br>}</pre> | no |
| <a name="input_use_existing_sa"></a> [use\_existing\_sa](#input\_use\_existing\_sa) | Use existing service accounts for control plane and worker nodes or not.<br>    If `true` parameters `master_service_account_id` and `node_service_account_id` must be set. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Kubernetes cluster certificate. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Kubernetes cluster ID. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes cluster name. |
| <a name="output_external_cluster_cmd"></a> [external\_cluster\_cmd](#output\_external\_cluster\_cmd) | Kubernetes cluster public IP address.<br>    Use the following command to download kube config and start working with Yandex Managed Kubernetes cluster:<br>    `$ yc managed-kubernetes cluster get-credentials --id <cluster_id> --external`<br>    This command will automatically add kube config for your user; after that, you will be able to test it with the<br>    `kubectl get cluster-info` command. |
| <a name="output_external_v4_address"></a> [external\_v4\_address](#output\_external\_v4\_address) | Kubernetes cluster external IP address. |
| <a name="output_external_v4_endpoint"></a> [external\_v4\_endpoint](#output\_external\_v4\_endpoint) | Kubernetes cluster external URL. |
| <a name="output_internal_cluster_cmd"></a> [internal\_cluster\_cmd](#output\_internal\_cluster\_cmd) | Kubernetes cluster private IP address.<br>    Use the following command to download kube config and start working with Yandex Managed Kubernetes cluster:<br>    `$ yc managed-kubernetes cluster get-credentials --id <cluster_id> --internal`<br>    Note: Kubernetes internal cluster nodes are available from the virtual machines in the same VPC as cluster nodes. |
| <a name="output_internal_v4_address"></a> [internal\_v4\_address](#output\_internal\_v4\_address) | Kubernetes cluster internal IP address.<br>    Note: Kubernetes internal cluster nodes are available from the virtual machines in the same VPC as cluster nodes. |
| <a name="output_internal_v4_endpoint"></a> [internal\_v4\_endpoint](#output\_internal\_v4\_endpoint) | Kubernetes cluster internal URL.<br>    Note: Kubernetes internal cluster nodes are available from the virtual machines in the same VPC as cluster nodes. |
| <a name="output_node_account_id"></a> [node\_account\_id](#output\_node\_account\_id) | Created IAM node account ID. |
| <a name="output_node_account_name"></a> [node\_account\_name](#output\_node\_account\_name) | Created IAM node account name. |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | Created IAM service account ID. |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Created IAM service account name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | > 3.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | > 0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | > 3.3 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.86.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_string.unique_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [yandex_iam_service_account.master](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account.node_account](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_kms_symmetric_key.kms_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | resource |
| [yandex_kms_symmetric_key_iam_binding.encrypter_decrypter](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key_iam_binding) | resource |
| [yandex_kubernetes_cluster.kube_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) | resource |
| [yandex_kubernetes_node_group.kube_node_groups](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group) | resource |
| [yandex_resourcemanager_folder_iam_member.node_account](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_calico_network_policy_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_cilium_network_policy_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_node_group_loadbalancer_role_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_node_group_public_role_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.sa_public_loadbalancers_role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_vpc_security_group.k8s_custom_rules_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.k8s_main_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.k8s_master_whitelist_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.k8s_nodes_ssh_access_sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group_rule.egress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress_rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_load_balancers"></a> [allow\_public\_load\_balancers](#input\_allow\_public\_load\_balancers) | Flag for creating new IAM role with a load-balancer.admin access. | `bool` | `true` | no |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | A list of allowed IPv4 CIDR blocks. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_allowed_ips_ssh"></a> [allowed\_ips\_ssh](#input\_allowed\_ips\_ssh) | A list of allowed IPv4 CIDR blocks for an access via SSH. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_ipv4_range"></a> [cluster\_ipv4\_range](#input\_cluster\_ipv4\_range) | CIDR block. IP range for allocating pod addresses.<br>  It should not overlap with any subnet in the network<br>  the Kubernetes cluster located in. Static routes will<br>  be set up for this CIDR blocks in node subnets. | `string` | `"172.17.0.0/16"` | no |
| <a name="input_cluster_ipv6_range"></a> [cluster\_ipv6\_range](#input\_cluster\_ipv6\_range) | IPv6 CIDR block. IP range for allocating pod addresses. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of a specific Kubernetes cluster. | `string` | `"k8s-cluster"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes cluster version | `string` | `"1.23"` | no |
| <a name="input_container_runtime_type"></a> [container\_runtime\_type](#input\_container\_runtime\_type) | Kubernetes Node Group container runtime type | `string` | `"containerd"` | no |
| <a name="input_create_kms"></a> [create\_kms](#input\_create\_kms) | Flag for enabling / disabling KMS key creation. | `bool` | `true` | no |
| <a name="input_custom_egress_rules"></a> [custom\_egress\_rules](#input\_custom\_egress\_rules) | A map definition of custom security egress rules.<br><br>Example:<pre>custom_egress_rules = {<br>  "rule1" = {<br>    protocol       = "ANY"<br>    description    = "rule-1"<br>    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]<br>    from_port      = 8090<br>    to_port        = 8099<br>  },<br>  "rule2" = {<br>    protocol       = "UDP"<br>    description    = "rule-2"<br>    v4_cidr_blocks = ["10.0.1.0/24"]<br>    from_port      = 8090<br>    to_port        = 8099<br>  }<br>}</pre> | `any` | `{}` | no |
| <a name="input_custom_ingress_rules"></a> [custom\_ingress\_rules](#input\_custom\_ingress\_rules) | A map definition of custom security ingress rules.<br><br>Example:<pre>custom_ingress_rules = {<br>  "rule1" = {<br>    protocol = "TCP"<br>    description = "rule-1"<br>    v4_cidr_blocks = ["0.0.0.0/0"]<br>    from_port = 3000<br>    to_port = 32767<br>  },<br>  "rule2" = {<br>    protocol = "TCP"<br>    description = "rule-2"<br>    v4_cidr_blocks = ["0.0.0.0/0"]<br>    port = 443<br>  },<br>  "rule3" = {<br>    protocol = "TCP"<br>    description = "rule-3"<br>    predefined_target = "self_security_group"<br>    from_port         = 0<br>    to_port           = 65535<br>  }<br>}</pre> | `any` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the Kubernetes cluster. | `string` | `"Yandex Managed K8S cluster"` | no |
| <a name="input_enable_cilium_policy"></a> [enable\_cilium\_policy](#input\_enable\_cilium\_policy) | Flag for enabling / disabling Cilium CNI. | `bool` | `false` | no |
| <a name="input_enable_default_rules"></a> [enable\_default\_rules](#input\_enable\_default\_rules) | Controls creation of default security rules.<br><br>Default security rules:<br> - allow all incoming traffic from ANY protocol<br> - allows master-node and node-node communication inside a security group<br> - allows pod-pod and service-service communication<br> - allows debugging ICMP packets from internal subnets<br> - allows incomming traffic from the Internet to the NodePort port range<br> - allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Yandex Object Storage, Docker Hub, and so on<br> - allow access to Kubernetes API via port 6443 from subnet<br> - allow access to Kubernetes API via port 443 from subnet<br> - allow access to worker nodes via SSH from allowed IPs range | `bool` | `true` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of the folder that the Kubernetes cluster belongs to. | `string` | `null` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | KMS symmetric key parameters. | `any` | `{}` | no |
| <a name="input_master_auto_upgrade"></a> [master\_auto\_upgrade](#input\_master\_auto\_upgrade) | Boolean flag that specifies if master can be upgraded automatically. | `bool` | `true` | no |
| <a name="input_master_labels"></a> [master\_labels](#input\_master\_labels) | A set of key/value label pairs to assign Kubernetes master nodes. | `map(string)` | `{}` | no |
| <a name="input_master_locations"></a> [master\_locations](#input\_master\_locations) | List of locations where cluster will be created. If list contains only ONE<br>location, will be created Zonal cluster, if THREE - Regional cluster.<br><br>NOTE: Master locations list must have only ONE or THREE locations! | <pre>list(object({<br>    zone      = string<br>    subnet_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_master_logging"></a> [master\_logging](#input\_master\_logging) | (Optional) Master Logging options. | `map` | <pre>{<br>  "enabled": true,<br>  "enabled_autoscaler": true,<br>  "enabled_events": true,<br>  "enabled_kube_apiserver": true,<br>  "folder_id": null<br>}</pre> | no |
| <a name="input_master_maintenance_windows"></a> [master\_maintenance\_windows](#input\_master\_maintenance\_windows) | List of structures that specifies maintenance windows,<br>    when auto update for master is allowed.<br><br>    Example:<pre>master_maintenance_windows = [<br>      {<br>        day        = "monday"<br>        start_time = "23:00"<br>        duration   = "3h"<br>      }<br>    ]</pre> | `list(map(string))` | `[]` | no |
| <a name="input_master_region"></a> [master\_region](#input\_master\_region) | Name of region where cluster will be created. Required for regional cluster,<br>not used for zonal cluster. | `string` | `"ru-central1"` | no |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | Kubernetes Node Group network acceleration type | `string` | `"standard"` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The ID of the cluster network. | `string` | n/a | yes |
| <a name="input_network_policy_provider"></a> [network\_policy\_provider](#input\_network\_policy\_provider) | Kubernetes cluster network policy provider | `string` | `"CALICO"` | no |
| <a name="input_node_account_name"></a> [node\_account\_name](#input\_node\_account\_name) | IAM node account name. | `string` | `"k8s-node-account"` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Kubernetes node groups map of maps. It could contain all parameters of yandex\_kubernetes\_node\_group resource,<br>    many of them could be NULL and have default values.<br><br>    Notes:<br>     - If node groups version isn't defined, cluster version will be used instead of.<br>     - A master locations list must have only one location for zonal cluster and three locations for a regional.<br>     - All node groups are able to define own locations. These locations will be used at first.<br>     - If own location aren't defined for node groups with auto scale policy, locations for these groups will be automatically generated from master locations. If node groups list have more than three groups, locations for them will be assigned from the beggining of the master locations list. So, all node groups will be distributed in a range of master locations. <br>     - Master locations will be used for fixed scale node groups.<br>     - Auto repair and upgrade values will be used master\_auto\_upgrade value.<br>     - Master maintenance windows will be used for Node groups also!<br>     - Only one max\_expansion OR max\_unavailable values should be specified for the deployment policy.<br><br>    Documentation - https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group<br><br>    Default values:<pre>platform_id     = "standard-v3"<br>      node_cores      = 4<br>      node_memory     = 8<br>      node_gpus       = 0<br>      core_fraction   = 100<br>      disk_type       = "network-ssd"<br>      disk_size       = 32<br>      preemptible     = false<br>      nat             = false<br>      auto_repair     = true<br>      auto_upgrade    = true<br>      maintenance_day           = "monday"<br>      maintenance_start_time    = "20:00"<br>      maintenance_duration      = "3h30m"<br>      network_acceleration_type = "standard"<br>      container_runtime_type    = "containerd"</pre>Example:<pre>node_groups = {<br>        "yc-k8s-ng-01"  = {<br>          cluster_name  = "k8s-kube-cluster"<br>          description   = "Kubernetes nodes group with fixed scale policy and one maintenance window"<br>          fixed_scale   = {<br>            size = 3<br>          }<br>          labels        = {<br>            owner       = "yandex"<br>            service     = "kubernetes"<br>          }<br>          node_labels   = {<br>            role        = "worker-01"<br>            environment = "dev"<br>          }<br>        },<br>        "yc-k8s-ng-02"  = {<br>          description   = "Kubernetes nodes group with auto scale policy"<br>          auto_scale    = {<br>            min         = 2<br>            max         = 4<br>            initial     = 2<br>          }<br>          node_locations   = [<br>            {<br>              zone      = "ru-central1-b"<br>              subnet_id = "e2lu07tr481h35012c8p"<br>            }<br>          ]<br>          labels        = {<br>            owner       = "example"<br>            service     = "kubernetes"<br>          }<br>          node_labels   = {<br>            role        = "worker-02"<br>            environment = "testing"<br>          }<br>        }<br>      }</pre> | `any` | `{}` | no |
| <a name="input_node_groups_defaults"></a> [node\_groups\_defaults](#input\_node\_groups\_defaults) | A map of common default values for Node groups. | `map` | <pre>{<br>  "core_fraction": 100,<br>  "disk_size": 32,<br>  "disk_type": "network-ssd",<br>  "ipv4": true,<br>  "ipv6": false,<br>  "nat": false,<br>  "node_cores": 4,<br>  "node_gpus": 0,<br>  "node_memory": 8,<br>  "platform_id": "standard-v3",<br>  "preemptible": false<br>}</pre> | no |
| <a name="input_node_ipv4_cidr_mask_size"></a> [node\_ipv4\_cidr\_mask\_size](#input\_node\_ipv4\_cidr\_mask\_size) | (Optional) Size of the masks that are assigned to each node in the cluster.<br>    Effectively limits maximum number of pods for each node. | `number` | `24` | no |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Public or private Kubernetes cluster | `bool` | `true` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | Kubernetes cluster release channel name | `string` | `"REGULAR"` | no |
| <a name="input_security_groups_ids_list"></a> [security\_groups\_ids\_list](#input\_security\_groups\_ids\_list) | List of security group IDs to which the Kubernetes cluster belongs | `list(string)` | `[]` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | IAM service account name. | `string` | `"k8s-service-account"` | no |
| <a name="input_service_ipv4_range"></a> [service\_ipv4\_range](#input\_service\_ipv4\_range) | CIDR block. IP range Kubernetes service cluster IP addresses<br>    will be allocated from. It should not overlap with<br>    any subnet in the network the Kubernetes cluster located in | `string` | `"172.18.0.0/16"` | no |
| <a name="input_service_ipv6_range"></a> [service\_ipv6\_range](#input\_service\_ipv6\_range) | IPv6 CIDR block. IP range for allocating pod addresses. | `string` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeouts. | `map(string)` | <pre>{<br>  "create": "60m",<br>  "delete": "60m",<br>  "update": "60m"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Kubernetes cluster ID. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes cluster name. |
| <a name="output_external_cluster_cmd"></a> [external\_cluster\_cmd](#output\_external\_cluster\_cmd) | Kubernetes cluster public IP address.<br>    Using following command to download kube config and start working with Yandex Managed Kubernetes cluster.<br>    $ yc managed-kubernetes cluster get-credentials --id <cluster\_id> --external<br>    This command will automatically add kube config for your user and after that you could test it with<br>    <kubectl get cluster-info> command. |
| <a name="output_internal_cluster_cmd"></a> [internal\_cluster\_cmd](#output\_internal\_cluster\_cmd) | Kubernetes cluster pricate IP address.<br>    Using following command to download kube config and start working with Yandex Managed Kubernetes cluster.<br>    $ yc managed-kubernetes cluster get-credentials --id <cluster\_id> --internal<br>    NOTE: Be aware Kubernetes internal cluster nodes are available from nodes in the same subnet as cluster nodes! |
| <a name="output_node_account_name"></a> [node\_account\_name_](#output\_node\_account\_name) | IAM node account name. |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | IAM service account name. |
<!-- END_TF_DOCS -->
