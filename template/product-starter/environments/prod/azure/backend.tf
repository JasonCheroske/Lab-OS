terraform {
  backend "azurerm" {
    resource_group_name  = "trf-tfstate-rg"
    storage_account_name = "trfstateprod"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}
