module "site" {
  source  = "./site_s3"
  version = "~> 1.3.0"

  domain              = local.config.domain
}


