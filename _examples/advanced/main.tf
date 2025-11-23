provider "digitalocean" {}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "terraform-do-modules/vpc/digitalocean"
  version     = "1.0.0"
  name        = "org-name"
  environment = "dev"
  region      = "nyc"
  ip_range    = "10.10.0.0/16"
}

##------------------------------------------------
## mysql database cluster module call
##------------------------------------------------
module "mysql" {
  source                       = "terraform-do-modules/database/digitalocean"
  version                      = "1.0.1"
  name                         = "org-name"
  environment                  = "dev"
  region                       = "nyc"
  cluster_engine               = "mysql"
  cluster_version              = "8"
  cluster_size                 = "db-s-1vcpu-1gb" # Explore more https://slugs.do-api.dev/ 
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  mysql_sql_mode               = "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES,ALLOW_INVALID_DATES"
  cluster_maintenance = {
    maintenance_hour = "02:00:00"
    maintenance_day  = "saturday"
  }
  databases = ["dev", "sit", "stg"]

  users = [
    {
      name              = "app-name",
      mysql_auth_plugin = "mysql_native_password"
    }
  ]
  create_firewall = false
  firewall_rules = [
    {
      type  = "ip_addr"
      value = "0.0.0.0"
    }
  ]
}


##------------------------------------------------
## app module call
##------------------------------------------------

module "app" {
  source  = "terraform-do-modules/app/digitalocean"
  version = "1.0.2"
  spec = [{
    name   = "app-name"
    region = "nyc"

    vpc = {
      id = module.vpc.id
    }

    database = {
      name         = "org-name-dev-mysql"
      engine       = "MYSQL"
      version      = "8"
      production   = true
      cluster_name = "org-name-dev-mysql"
      db_name      = "dev"
      db_user      = "app-name"
    }

    service = {
      name = "app-name"
      image = {
        registry_type  = "DOCKER_HUB"
        registry       = "songhanpoo"
        repository     = "wordpress-ols"
        tag            = "0.1.2"
        internal_ports = "80"
        deploy_on_push = {
          enabled = true
        }
      }

      alert = {
        rule     = "CPU_UTILIZATION"
        value    = 50
        operator = "GREATER_THAN"
        window   = "FIVE_MINUTES"
        disabled = false
      }

      env = [
        {
          key   = "DATABASE_HOST",
          type  = "GENERAL",
          value = module.mysql.database_cluster_private_host,
        },
        {
          key   = "DATABASE_PORT_NUMBER",
          type  = "GENERAL"
          value = module.mysql.database_cluster_port,
        },
        {
          key   = "DATABASE_NAME",
          type  = "GENERAL",
          value = "dev",
        },
        {
          key   = "DATABASE_USER",
          type  = "SECRET",
          value = "app-name",
        },
        {
          key   = "DATABASE_PASSWORD",
          type  = "SECRET",
          value = module.mysql.database_cluster_password,
        },
      ]
    }
  }]
}
