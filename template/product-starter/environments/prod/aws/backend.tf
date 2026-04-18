terraform {
  backend "s3" {
    bucket         = "tfstate-prod-local"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tflock-prod-local"
    encrypt        = true
  }
}
