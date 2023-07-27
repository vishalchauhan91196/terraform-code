locals {
  application = "app"

  payload_vpcs = {
    us-east-1 = [
      {
        name  = "${local.application}-${var.environment}-${var.region}-vpc"
        cidr  = "10.6.0.0/16"
      }
    ]
  }

  payload_route_tables = {
    us-east-1 = [
      {
        name     = "${local.application}-${var.environment}-${var.region}-rt-public"
        vpc_name = "${local.application}-${var.environment}-${var.region}-vpc"
      },
      {
        name     = "${local.application}-${var.environment}-${var.region}-rt-private"
        vpc_name = "${local.application}-${var.environment}-${var.region}-vpc"
      },
      {
        name     = "${local.application}-${var.environment}-${var.region}-rt-database"
        vpc_name = "${local.application}-${var.environment}-${var.region}-vpc"
      },
      {
        name     = "${local.application}-${var.environment}-${var.region}-rt-tgw"
        vpc_name = "${local.application}-${var.environment}-${var.region}-vpc"
      }
    ]
  }

  payload_subnets = {
    us-east-1 = [
      {
        name                = "${local.application}-${var.environment}-${var.region}-public-azA"
        cidr_block          = "10.6.0.0/21"
        vpc_name            = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone   = "${var.region}a"
        route_table_name    = "${local.application}-${var.environment}-${var.region}-rt-public"
        public_ip_on_launch = true
      },
      {
        name                = "${local.application}-${var.environment}-${var.region}-public-azB"
        cidr_block          = "10.6.8.0/21"
        vpc_name            = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone   = "${var.region}b"
        route_table_name    = "${local.application}-${var.environment}-${var.region}-rt-public"
        public_ip_on_launch = true
      },
      {
        name              = "${local.application}-${var.environment}-${var.region}-private-azA"
        cidr_block        = "10.6.32.0/20"
        vpc_name          = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone = "${var.region}a"
        route_table_name  = "${local.application}-${var.environment}-${var.region}-rt-private"
      },
      {
        name              = "${local.application}-${var.environment}-${var.region}-private-azB"
        cidr_block        = "10.6.48.0/20"
        vpc_name          = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone = "${var.region}b"
        route_table_name  = "${local.application}-${var.environment}-${var.region}-rt-private"
        },
      {
        name              = "${local.application}-${var.environment}-${var.region}-database-azA"
        cidr_block        = "10.6.96.0/22"
        vpc_name          = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone = "${var.region}a"
        route_table_name  = "${local.application}-${var.environment}-${var.region}-rt-database"
      },
      {
        name              = "${local.application}-${var.environment}-${var.region}-database-azB"
        cidr_block        = "10.6.100.0/22"
        vpc_name          = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone = "${var.region}b"
        route_table_name  = "${local.application}-${var.environment}-${var.region}-rt-database"
      },
      {
        name              = "${local.application}-${var.environment}-${var.region}-tgw-azA"
        cidr_block        = "10.6.127.192/27"
        vpc_name          = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone = "${var.region}a"
        route_table_name  = "${local.application}-${var.environment}-${var.region}-rt-tgw"
      },
      {
        name              = "${local.application}-${var.environment}-${var.region}-tgw-azB"
        cidr_block        = "10.6.127.224/27"
        vpc_name          = "${local.application}-${var.environment}-${var.region}-vpc"
        availability_zone = "${var.region}b"
        route_table_name  = "${local.application}-${var.environment}-${var.region}-rt-tgw"
      }
    ]
  }

  payload_igws = {
    us-east-1 = [
      {
        name      = "${local.application}-${var.environment}-${var.region}-igw"
        vpc_name  = "${local.application}-${var.environment}-${var.region}-vpc"
      }
    ]
  }

  payload_nats = {
    us-east-1 = [
      {
        name        = "${local.application}-${var.environment}-${var.region}-nat-azA"
        subnet_name = "${local.application}-${var.environment}-${var.region}-public-azA"
      }
    ]
  }

  payload_routes = {
    us-east-1 = [
      {
        description            = "public-subnet-to-internet-via-igw"
        gateway_name           = "${local.application}-${var.environment}-${var.region}-igw"
        destination_cidr_block = "0.0.0.0/0"
        route_table_name       = "${local.application}-${var.environment}-${var.region}-rt-public"
      },
      {
        description             = "private-subnet-to-internet-via-natgw"
        nat_gateway_name        = "${local.application}-${var.environment}-${var.region}-nat-azA"
        destination_cidr_block  = "0.0.0.0/0"
        route_table_name        = "${local.application}-${var.environment}-${var.region}-rt-private"
      },
      {
        description             = "database-subnet-to-internet-via-natgw"
        nat_gateway_name        = "${local.application}-${var.environment}-${var.region}-nat-azA"
        destination_cidr_block  = "0.0.0.0/0"
        route_table_name        = "${local.application}-${var.environment}-${var.region}-rt-database"
      },
      {
        description            = "public-subnet-to-tgw"
        transit_gateway_name    = "${local.application}-${var.environment}-${var.region}-tgw"
        destination_cidr_block = "10.0.0.0/8"
        route_table_name       = "${local.application}-${var.environment}-${var.region}-rt-public"
      },
      {
        description             = "private-subnet-to-tgw"
        transit_gateway_name    = "${local.application}-${var.environment}-${var.region}-tgw"
        destination_cidr_block  = "10.0.0.0/8"
        route_table_name        = "${local.application}-${var.environment}-${var.region}-rt-private"
      },
      {
        description             = "database-subnet-to-tgw"
        transit_gateway_name    = "${local.application}-${var.environment}-${var.region}-tgw"
        destination_cidr_block  = "10.0.0.0/8"
        route_table_name        = "${local.application}-${var.environment}-${var.region}-rt-database"
      },
      {
        description             = "tgw-subnet-to-tgw"
        transit_gateway_name    = "${local.application}-${var.environment}-${var.region}-tgw"
        destination_cidr_block  = "0.0.0.0/0"
        route_table_name        = "${local.application}-${var.environment}-${var.region}-rt-tgw"
      }
    ]
  }

  payload_rds_cidr_rules  = {
    us-east-1 = [
      {
        type        = "ingress"
        cidr_blocks = [module.vpc.vpc_cidr_blocks["${local.application}-${var.environment}-${var.region}-vpc"]]
        from_port   = 1433
        to_port     = 1433
        protocol    = "tcp"
        description = "Allow IPv4 MSSQL inbound traffic"
      },
      {
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "Allow IPv4 all outbound traffic"
      },
      {
        type        = "egress"
        ipv6_cidr_blocks = ["::/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "Allow IPv6 all outbound traffic"
      }
    ]
  }

  payload_rds_instance = {
    us-east-1 = [
      {
        name        = "${local.application}-${var.environment}-${var.region}-mssql-rds"
        description = "${local.application} ${var.environment} MSSQL RDS Instance"
        subnet_name = ["${local.application}-${var.environment}-${var.region}-database-azA", "${local.application}-${var.environment}-${var.region}-database-azB"]
        engine            = "sqlserver-ex"
        engine_version    = "15.00.4236.7.v1"
        instance_class    = "db.t3.medium"
        allocated_storage  = 40
        username           = var.rds_username
        password           = var.rds_password
      }
    ]
  }

  payload_secrets_manager = {
    us-east-1 = [
      {
        name          = "${local.application}-${var.environment}-${var.region}-secrets-manager"
        description   = "Access to MSSQL ${var.environment} database for ${local.application} in ${var.region} region"
        rds_name      = "${local.application}-${var.environment}-${var.region}-mssql-rds"
        rds_username  = var.rds_username
        rds_password  = var.rds_password
      }
    ]
  }
}