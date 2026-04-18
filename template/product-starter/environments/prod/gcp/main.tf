module "networking" {
  source = "../../../modules/networking/gcp"

  cidr_block  = var.vpc_cidr
  project     = var.gcp_project
  region      = var.gcp_region
  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "messaging" {
  source = "../../../modules/messaging/gcp"

  project     = var.gcp_project
  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "database_sql" {
  count  = var.emulator_mode ? 0 : 1
  source = "../../../modules/database/sql/gcp"

  project     = var.gcp_project
  region      = var.gcp_region
  network_id  = module.networking.vpc_id
  db_password = var.db_password
  tier        = "db-n1-standard-4"
  availability_type = "REGIONAL"
  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "kubernetes" {
  count  = var.emulator_mode ? 0 : 1
  source = "../../../modules/kubernetes/gcp"

  project           = var.gcp_project
  region            = var.gcp_region
  network_id        = module.networking.vpc_id
  subnet_id         = module.networking.private_subnet_ids[0]
  node_machine_type = "n2-standard-4"
  node_count        = 3
  team              = var.team
  environment       = var.environment
  owner             = var.owner
}
