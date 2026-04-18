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
  count  = var.emulator_mode ? 1 : 1 # Pub/Sub: covered by GCP emulator (always enabled)
  source = "../../../modules/messaging/gcp"

  project     = var.gcp_project
  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "database_sql" {
  count  = var.emulator_mode ? 0 : 1 # Cloud SQL: not covered by GCP emulators
  source = "../../../modules/database/sql/gcp"

  project        = var.gcp_project
  region         = var.gcp_region
  network_id     = module.networking.vpc_id
  db_password    = var.db_password
  tier           = "db-f1-micro"
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}

module "kubernetes" {
  count  = var.emulator_mode ? 0 : 1 # GKE: not covered by GCP emulators
  source = "../../../modules/kubernetes/gcp"

  project            = var.gcp_project
  region             = var.gcp_region
  network_id         = module.networking.vpc_id
  subnet_id          = module.networking.private_subnet_ids[0]
  node_machine_type  = "e2-medium"
  node_count         = 1
  team               = var.team
  environment        = var.environment
  owner              = var.owner
}
