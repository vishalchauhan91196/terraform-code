module "rds_sg_useast1" {
  source                = "https://github.com/vishalchauhan91196/terraform-modules.git//security-group"
  create                = true
  name                  = "${local.application}-${var.environment}-${var.region}-mssql-rds-security-group"
  vpc_id                = module.vpc.vpc_ids["${local.application}-${var.environment}-${var.region}-vpc"]
  source_cidr_block     = true
  source_cidr_rules     = local.payload_rds_cidr_rules[var.region]
  source_security_group = false
  source_self           = false
}

module "rds" {
  source                  = "https://github.com/vishalchauhan91196/terraform-modules.git//rds-db"
  payload_rds_instance    = local.payload_rds_instance[var.region]
  subnet_ids              = module.subnet.subnet_ids
  vpc_security_group_ids  = [module.rds_sg_useast1.security_group_id]
}

module "secrets_manager" {
  source                    = "https://github.com/vishalchauhan91196/terraform-modules.git//secrets-manager"
  payload_secrets_manager   = local.payload_secrets_manager[var.region]
  rds_engine                = module.rds.db_instance_engine
  rds_address               = module.rds.db_instance_address
  rds_dbInstanceIdentifier  = module.rds.db_instance_id
}
