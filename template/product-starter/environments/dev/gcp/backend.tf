terraform {
  backend "gcs" {
    bucket = "trf-tfstate-dev"
    prefix = "dev/terraform.tfstate"
  }
}
