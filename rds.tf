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

module "lambda-scheduler-ec2-stop-start" {
  source         = "https://github.com/vishalchauhan91196/terraform-modules.git//lambda-scheduler-ec2-stop-start"
  application    = local.application
  environment    = var.environment
  region         = var.region
}
