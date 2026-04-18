provider "azurerm" {
  features {}
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
  # skip_provider_registration avoids needing Contributor on the subscription for local study.
  skip_provider_registration = var.emulator_mode
}
