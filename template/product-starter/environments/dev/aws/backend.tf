terraform {
  backend "s3" {
    bucket         = "tfstate-dev-local"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tflock-dev-local"
    encrypt        = true
  }
}
