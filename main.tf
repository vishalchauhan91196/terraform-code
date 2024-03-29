module "vpc" {
  source    = "https://github.com/vishalchauhan91196/terraform-modules.git//vpc"
  vpc_vars  = local.payload_vpcs[var.region]
  assign_generated_ipv6_cidr_block  = true
}

module "route_tables" {
  source                = "https://github.com/vishalchauhan91196/terraform-modules.git//route-table"
  payload_route_tables  = local.payload_route_tables[var.region]
  vpc_ids               = module.vpc.vpc_ids
}

module "subnet" {
  source          = "https://github.com/vishalchauhan91196/terraform-modules.git//subnet"
  payload_subnets = local.payload_subnets[var.region]
  vpc_ids         = module.vpc.vpc_ids
  route_table_ids = module.route_tables.route_table_ids
  vpc_ipv6_cidr   = module.vpc.ipv6_cidr_block
}

module "igws" {
  source        = "https://github.com/vishalchauhan91196/terraform-modules.git//internet-gw"
  payload_igws  = local.payload_igws[var.region]
  vpc_ids       = module.vpc.vpc_ids
}

module "nat_gws" {
  source        = "https://github.com/vishalchauhan91196/terraform-modules.git//nat-gw"
  payload_nats  = local.payload_nats[var.region]
  subnet_ids    = module.subnet.subnet_ids
}

module "vpc_routes" {
  source              = "https://github.com/vishalchauhan91196/terraform-modules.git//vpc-routes"
  payload_routes      = local.payload_routes[var.region]
  route_table_ids     = module.route_tables.route_table_ids
  gateway_ids         = module.igws.igw_ids
  nat_gateway_id      = module.nat_gws.nat_ids
}

module "lambda-scheduler-ec2-stop-start" {
  source         = "https://github.com/vishalchauhan91196/terraform-modules.git//lambda-scheduler-ec2-stop-start"
  application    = local.application
  environment    = var.environment
  region         = var.region
}

module "fsx_sg_useast1" {
  source                = "https://github.com/vishalchauhan91196/terraform-modules.git//security-group"
  create                = true
  name                  = "${local.application}-${var.environment}-${var.region}-fsx-security-group"
  vpc_id                = module.vpc.vpc_ids["${local.application}-${var.environment}-${var.region}-vpc"]
  source_cidr_block     = true
  source_cidr_rules     = local.payload_fsx_cidr_rules[var.region]
  source_security_group = false
  source_self           = false
  tags                  = local.common_tags
}

module "fsx" {
  source                          = "https://github.com/vishalchauhan91196/terraform-modules.git//fsx"
  payload_fsx                     = local.payload_fsx[var.region]
  subnet_ids                      = module.subnet.subnet_ids
  aws_directory_service_directory = module.directory_service.id
  security_group_ids              = [module.fsx_sg_useast1.security_group_id]
  tags                            = local.common_tags
}



