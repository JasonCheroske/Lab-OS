terraform {
  backend "gcs" {
    bucket = "trf-tfstate-prod"
    prefix = "prod/terraform.tfstate"
  }
}
