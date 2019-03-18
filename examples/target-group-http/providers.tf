provider "aws" {
  profile                     = "appzen-dev"
  version                     = "1.60.0"
  region                      = "${var.region}"
  skip_credentials_validation = true
  skip_get_ec2_platforms      = true
  skip_region_validation      = true
}
