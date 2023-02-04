resource "azurerm_resource_group" "aks" {
  name     = "${local.name_prefix}-aks"
  location = var.region
}
