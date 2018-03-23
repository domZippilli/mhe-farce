variable "access_key" {}
variable "secret_key" {}
variable "region" {}

provider "aws" {
  version    = "~> 1.11"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
