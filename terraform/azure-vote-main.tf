# Configure the Microsoft Azure Provider
variable "azure_subscription_id" {}

variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}
variable "project_code" {}
variable "project_region" {}
variable "region_suffix" {}
variable "admin_username" {}
variable "ssh_keydata" {}

provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
}

resource "azurerm_resource_group" "rg" {
  name     = "RG${var.region_suffix}${var.project_code}D01"
  location = "${var.project_region}"
}

resource "azurerm_storage_account" "votingsa" {
  name                     = "sa${lower(var.region_suffix)}${lower(var.project_code)}d01"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_container_registry" "votingcr" {
  name                = "cr${lower(var.region_suffix)}${lower(var.project_code)}d01"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  admin_enabled       = true
  sku                 = "Classic"
  storage_account_id  = "${azurerm_storage_account.votingsa.id}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks${var.region_suffix}${var.project_code}d01"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_prefix          = "aksmaster${var.region_suffix}${var.project_code}d01"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${var.ssh_keydata}"
    }
  }

  agent_pool_profile {
    name    = "default"
    count   = 2
    vm_size = "Standard_D3"
  }

  service_principal {
    client_id     = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
  }

  tags {
    Environment = "Production"
  }
}

output "id" {
  value = "${azurerm_kubernetes_cluster.aks.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
}
