module "production_env" {
  source = "../.."
  region = "us-east-1"

  ipv4_cloudflare = split("\n", chomp(file(".cloudflare/ipv4_cidrs")))
  ipv6_cloudflare = split("\n", chomp(file(".cloudflare/ipv6_cidrs")))

  env_name = "production-${random_string.suffix[0].result}"
  app_name = "flask"
  
  db_name = "x${random_string.suffix[1].result}"
  db_username = random_string.suffix[2].result
  db_password = random_password.password.result
}

resource "random_string" "suffix" {
  count = 3
  length  = 8
  special = false
  upper = false
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# output "DB_endpoint" {
#     value = module.production_env.db_endpoint
# }

output "LB_endpoint" {
  value = module.production_env.lb_endpoint
}