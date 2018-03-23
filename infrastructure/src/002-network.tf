variable "zone_a_subnet_id" {}
variable "zone_b_subnet_id" {}

# Since these are provided by another team,
# I have made them data providers

data "aws_subnet" "zone_a" {
  id = "${var.zone_a_subnet_id}"
}

data "aws_subnet" "zone_b" {
  id = "${var.zone_b_subnet_id}"
}
