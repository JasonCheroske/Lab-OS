tflint {
  required_version = ">= 0.50.0"
}

config {
  module = true
}

# AWS ruleset — covers all modules/*/aws/ and environments/*/aws/
plugin "aws" {
  enabled = true
  version = "0.30.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Azure ruleset — covers all modules/*/azure/ and environments/*/azure/
# Run with: tflint --chdir environments/dev/azure
plugin "azurerm" {
  enabled = true
  version = "0.26.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# GCP ruleset — covers all modules/*/gcp/ and environments/*/gcp/
# Run with: tflint --chdir environments/dev/gcp
plugin "google" {
  enabled = true
  version = "0.28.0"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}
