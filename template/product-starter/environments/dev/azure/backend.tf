terraform {
  backend "azurerm" {
    resource_group_name  = "trf-tfstate-rg"
    storage_account_name = "trfstatedev"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}
