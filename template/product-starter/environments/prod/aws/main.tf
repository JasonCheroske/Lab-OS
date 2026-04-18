module "networking" {
  source = "../../../modules/networking/aws"

  cidr_block         = var.vpc_cidr
  azs                = var.azs
  enable_nat_gateway = var.enable_nat_gateway
  team               = var.team
  environment        = var.environment
  owner              = var.owner
}

module "messaging" {
  source = "../../../modules/messaging/aws"

  team        = var.team
  environment = var.environment
  owner       = var.owner
}

module "database_sql" {
  source = "../../../modules/database/sql/aws"

  vpc_id              = module.networking.vpc_id
  db_subnet_ids       = module.networking.private_subnet_ids
  allowed_cidr_blocks = [module.networking.cidr_block]
  instance_class      = "db.r6g.large"
  allocated_storage   = 100
  db_username         = var.db_username
  db_password         = var.db_password
  multi_az            = true
  team                = var.team
  environment         = var.environment
  owner               = var.owner
}

module "kubernetes" {
  count  = var.emulator_mode ? 0 : 1 # EKS: not emulated by LocalStack Community
  source = "../../../modules/kubernetes/aws"

  vpc_id             = module.networking.vpc_id
  subnet_ids         = concat(module.networking.public_subnet_ids, module.networking.private_subnet_ids)
  private_subnet_ids = module.networking.private_subnet_ids

  node_instance_types    = ["m5.xlarge"]
  node_desired_size      = 3
  node_min_size          = 2
  node_max_size          = 10
  endpoint_public_access = false

  team        = var.team
  environment = var.environment
  owner       = var.owner
}
