
data "azurerm_log_analytics_workspace" "logs" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.vnet_resource_group_name
}

# module "ssh-key" {
#   source         = "../ssh-key"
#   public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
# }


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  count    = var.public_ssh_key == "" ? 1 : 0
  content  = tls_private_key.ssh.private_key_pem
  filename = "./private_ssh_key"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks"
  kubernetes_version  = var.kubernetes_version
  # private_dns_zone_id = var.private_dns_zone_id     

  #security
  private_cluster_enabled     = false
  azure_policy_enabled        = true 
  # open_service_mesh_enabled   = true  
  sku_tier                    = var.sku_tier
  oidc_issuer_enabled         = true


  default_node_pool {
    name                    = "default"
    # node_count              = var.default_node_count
    vm_size                 = var.default_vm_size
    type                    = var.node_pool_type 
    # tags                    = var.tags
    max_pods                = var.default_pool_max_pods
    vnet_subnet_id          = data.azurerm_subnet.aks_subnet.id
    # pod_subnet_id           = var.workload_linux_subnet_id
    enable_host_encryption  = false
    enable_auto_scaling     = true
    min_count               = 2
    max_count               = 10
    zones                   = ["1","2","3"]
    node_labels             = {
      workload_type = "system"
    }
  }

  linux_profile {
    admin_username      = "azureadminuser"
    ssh_key {
        key_data        = replace(var.public_ssh_key == "" ? tls_private_key.ssh.public_key_openssh : var.public_ssh_key, "\n", "")
    }      
  }

  identity {
    type         = "SystemAssigned"
  }

  oms_agent  {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
    secret_rotation_interval = "2m"
  }

  role_based_access_control_enabled = true

  # azure_active_directory_role_based_access_control{
  #   managed = true
  #   # tenant_id = var.tenant_id
  #   admin_group_object_ids = ["a4e5ec83-a839-4d3a-9b73-718f04a7e892"]
  #   azure_rbac_enabled = true
  # }
  
  network_profile {
      network_plugin      = var.network_plugin
      service_cidr        = "10.240.0.0/16"
      dns_service_ip      =  "10.240.0.10"
      outbound_type       = "loadBalancer"
      network_policy      = "calico"
  }

  storage_profile {
    blob_driver_enabled = true
  }

  # tags = var.tags
}

# resource "azurerm_kubernetes_cluster_node_pool" "workload_linux" {
#     name                    = "lightapps"
#     kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks.id
#     # node_count              = var.workload_node_count
#     vm_size                 = var.workload_vm_size
#     tags                    = var.tags
#     max_pods                = var.default_pool_max_pods
#     vnet_subnet_id          = var.aks_subnet_id
#     enable_host_encryption  = false
#     enable_auto_scaling     = true
#     os_type                 = var.workload_os_type
#     min_count               = var.workload_node_count
#     max_count               = 10
#     zones                   = ["1","2","3"]
#     node_labels = {
#       workload_type = "application_linux"
#     }
#   }


# resource "azurerm_monitor_diagnostic_setting" "aks-logging" {
#   name                                  = azurerm_kubernetes_cluster.aks.name
#   target_resource_id                    = azurerm_kubernetes_cluster.aks.id
#   log_analytics_workspace_id            = var.azurerm_log_analytics_workspace_id

  #  log {
  #   category = "csi-azuredisk-controller"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  #  log {
  #   category = "csi-azurefile-controller"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  #  log {
  #   category = "csi-snapshot-controller"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  #  log {
  #   category = "cloud-controller-manager"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  #  log {
  #   category = "kube-audit-admin"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }
  
  
  # log {
  #   category = "kube-scheduler"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  # log {
  #   category = "kube-controller-manager"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  # log {
  #   category = "cluster-autoscaler"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  # log {
  #   category = "kube-audit"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  #   log {
  #   category = "guard"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  # log {
  #   category = "kube-apiserver"
  #   enabled  = true

  #   retention_policy {
  #     enabled = false
  #   }
  # }

  # metric {
  #   category = "AllMetrics"

  #   retention_policy {
  #     enabled = false
  #   }
  # }
# }

