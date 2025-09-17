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
  - When enabling OS Login for node-groups, you should have the external ip addresses for nodes (`var.node_groups_defaults.nat` must be `true`).

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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
