provider "azurerm" {
  # Configuration options
  version = "=2.36.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "covid-19-rg"
  location = "eastus"
}

resource "azurerm_container_group" "acg" {
  name                = "covidContainerGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "alpine"
    image  = "alpine:3.12.0"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "alpine"
    image  = "alpine:3.12.0"
    cpu    = "0.5"
    memory = "1.5"
  }

  container {
    name   = "alpine"
    image  = "alpine:3.12.0"
    cpu    = "0.5"
    memory = "1.5"
  }  


  tags = {
    environment = "production"
  }
}

resource "azurerm_kubernetes_cluster" "rg" {
  name                = "covid-19-akc"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "covid-aks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = "00000000-0000-0000-0000-000000000000"
    client_secret = "00000000000000000000000000000000"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "example" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.rg.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 3

  tags = {
    Environment = "Production"
  }
}
