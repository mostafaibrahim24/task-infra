module "app-infra" {
  source = "./modules/app-infra"
  region             = var.region
  infra_env          = var.infra_env
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  az_list            = var.az_list
  instance_type      = var.instance_type
  rds_instance_class = var.rds_instance_class
  rds_username       = var.rds_username
  rds_password       = var.rds_password
  alert_email        = var.alert_email
}