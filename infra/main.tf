module "services" {
  source       = "./modules/project_services"
  project_id   = var.project_id
  api_services = var.api_services
}

module "secrets" {
  source   = "./modules/secrets"
  services = module.services.enabled_services
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  service_account_id = var.service_account_id
  services = module.services.enabled_services
}

module "network" {
  source               = "./modules/network"
  vpc_name             = var.vpc_name
  region               = var.region
  private_subnet_name  = var.private_subnet_name
  private_cidr         = var.private_cidr
  create_public_subnet = true
  public_subnet_name   = var.public_subnet_name
  public_cidr          = var.public_cidr
  services             = module.services.enabled_services
}

module "sql" {
  source           = "./modules/sql"
  region           = var.region
  vpc_self_link    = module.network.vpc_self_link
  db_instance_name = var.db_instance_name
  db_name          = var.db_name
  db_user          = var.db_user
  db_password      = module.secrets.db_password
  services         = module.services.enabled_services
  depends_on       = [module.network]
}

module "vpc_connector" {
  source             = "./modules/vpc_connector"
  vpc_self_link      = module.network.vpc_self_link
  region             = var.region
  vpc_connector_name = var.vpc_connector_name
  vpc_connector_cidr = var.vpc_connector_cidr
  services           = module.services.enabled_services
}

module "artifact_registry" {
  source        = "./modules/artifact_registry"
  project_id    = var.project_id
  region        = var.region
  repository_id = var.repository_id
  services      = module.services.enabled_services
}

module "cloud_run" {
  source              = "./modules/cloud_run"
  project_id          = var.project_id
  region              = var.region
  cloud_run_name      = var.cloud_run_name
  run_service_account = module.iam.service_account_email
  app_image           = module.artifact_registry.app_image
  vpc_connector_id    = module.vpc_connector.vpc_connector_id
  db_name             = var.db_name
  db_user             = var.db_user
  db_port             = var.db_port
  db_private_ip       = module.sql.db_private_ip
  db_secret_name      = module.secrets.db_secret_name
  services            = module.services.enabled_services
  depends_on       = [module.network]
}

module "monitoring" {
  source = "./modules/monitoring"
  cloud_run_service_name = var.cloud_run_name
  alert_email           = var.alert_email
  google_chat_space   = var.google_chat_space
  memory_limit_bytes  = var.memory_limit_bytes
  depends_on            = [module.cloud_run]
}
