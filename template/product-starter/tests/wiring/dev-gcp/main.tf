# Wiring test configuration for dev/gcp.
# Mirrors environments/dev/gcp/main.tf without emulator_mode gating
# so all module connections are exercised by the mock provider.

module "networking" {
  source = "../../../modules/networking/gcp"

  cidr_block         = var.vpc_cidr
  azs                = var.azs
  project            = var.gcp_project
  region             = var.gcp_region
  enable_nat_gateway = var.enable_nat_gateway
  team               = var.team
  environment        = var.environment
  owner              = var.owner
}

module "messaging" {
  source = "../../../modules/messaging/gcp"

  project     = var.gcp_project
  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "database_sql" {
  source = "../../../modules/database/sql/gcp"

  project     = var.gcp_project
  region      = var.gcp_region
  network_id  = module.networking.vpc_id
  db_password = var.db_password
  tier        = "db-f1-micro"
  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "kubernetes" {
  source = "../../../modules/kubernetes/gcp"

  project           = var.gcp_project
  region            = var.gcp_region
  network_id        = module.networking.vpc_id
  subnet_id         = module.networking.private_subnet_ids[0]
  node_machine_type = "e2-medium"
  node_count        = 1
  team              = var.team
  environment       = var.environment
  owner             = var.owner
}
