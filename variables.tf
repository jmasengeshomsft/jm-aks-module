variable "resource_group_name" {
    description = "Application Gateway Resource Group"
}

variable "location" {
    description = "cluster location"
}

variable "virtual_network_name" {
    description = "The name of the vnet"
}

variable "vnet_resource_group_name" {
    description = "The name of the vnet"
}

variable "aks_subnet_name" {
    description = "The name of the subnet"
}

# variable "aks_subnet_id" {
#     description = "The id of the subnet to attach to the udr"
# }

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  default     = ""
}

variable "linux_admin_user" {
    description = "admin user"
    default     = "azureadminuser"
}

variable "aks_cluster_name" {
    description = "The name of the cluster"
}

variable "workspace_name" {
    description = "The name of the law"
}

# variable "private_dns_zone_id" {
#     description = "The ID of the DNS Zone for the Private Link"
# }

variable "kubernetes_version" {
    description = "Kubernetes version"
}

variable "default_node_count" {
    description = "Pool node count"
    default     = 3
}

variable "workload_os_type" {
    description = "The Os Type"
    default     = "Linux"
}

variable "workload_node_count" {
    description = "Pool node count"
    default     = 2
}

# variable "workload_linux_subnet_id" {
#     description = "The subnet for linux workload pods"
# }

# variable "azurerm_log_analytics_workspace_id" {
#     description = "The id of the log analytics woskpace"

# }

variable "default_pool_max_pods" {
    description = "The number of pods on the default node pool"
    default     = 200
}

variable "workload_pool_max_pods" {
    description = "The number of pods on the workload node pool"
    default     = 200
}

variable "sku_tier" {
  description = "Use Uptime SLA or Not"
  default = "Free"
}

# variable "default_pod_subnet_id" {
#     description = "The subnet for pods on the default pool"
# }

variable "default_vm_size" {
    description = "VM Size"
    default     = "Standard_D2_v2"
}

variable "workload_vm_size" {
    description = "VM Size"
    default     = "Standard_D2_v2"
}

variable "node_pool_type" {
    description = "VM type: AvailabilitySet or VirtualMachineScaleSets"
    default     = "VirtualMachineScaleSets"
}

# variable "service_principal_client_id" {
#     description = "The client id for the service principal "
# }

# variable "service_principal_client_secret" {
#     description = "The client secret for the service principal"
# }


variable "network_plugin" {
    description = "The network plugin: Azure/Kubenet"
    default     = "kubenet"
}

variable "network_policy" {
    description = "The network plugin: Azure/Kubenet"
    default     = "calico"
}


variable "service_cidr" {
    description = "Service Address Space"
    default     = "10.240.0.0/16"
}

variable "dns_service_ip" {
    description = "Service Address Space"
    default     = "10.240.0.10"
}

variable "outbound_type" {
    description = "Out bound type: userDefinedRouting/loadBalancer"
    default     = "userDefinedRouting"
}

# variable "tenant_id" {
#     description = "Tenant aad"
# }

variable "azure_aad_admin_group_id" {
    description = "The default aad group"
    default = "aa4e5ec83-a839-4d3a-9b73-718f04a7e892"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  default     =  {
  }
}