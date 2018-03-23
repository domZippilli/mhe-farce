variable "deployment_vpc_id" {}

resource "aws_security_group" "internet_gitlab_service" {
  name        = "internet_gitlab_service"
  description = "Allow all inbound https"
  vpc_id      = "${var.deployment_vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "internet_gitlab_service"
  }
}

resource "aws_security_group" "provide_gitlab_services" {
  name        = "provide_gitlab_service"
  description = "Allow all inbound https/ssh from CIDR"
  vpc_id      = "${var.deployment_vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${data.aws_subnet.zone_a.cidr_block}",
      "${data.aws_subnet.zone_b.cidr_block}",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "${data.aws_subnet.zone_a.cidr_block}",
      "${data.aws_subnet.zone_b.cidr_block}",
    ]
  }

  tags {
    Name = "internet_https_service"
  }
}

resource "aws_security_group" "use_internet_smtp" {
  name        = "use_internet_smtp"
  description = "Allow outbound smtp"
  vpc_id      = "${var.deployment_vpc_id}"

  egress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "use_internet_smtp"
  }
}

resource "aws_security_group" "use_mhe_snmp_monitoring" {
  name        = "use_mhe_snp_monitoring"
  description = "Allow outbound snmp"
  vpc_id      = "${var.deployment_vpc_id}"

  egress {
    from_port   = 161
    to_port     = 161
    protocol    = "udp"
    cidr_blocks = ["10.20.0.0/15"]
  }

  tags {
    Name = "use_mhe_snp_monitoring"
  }
}

resource "aws_security_group" "mhe_gitlab_admin_services" {
  name        = "mhe_gitlab_admin_services"
  description = "Allow all admin traffic from office LAN"
  vpc_id      = "${var.deployment_vpc_id}"

  ingress {
    from_port   = 122
    to_port     = 122
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/15", "10.23.0.0/16", "10.22.0.0/18"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/15", "10.23.0.0/16", "10.22.0.0/18"]
  }

  tags {
    Name = "mhe_gitlab_admin_services"
  }
}

resource "aws_security_group" "mhe_gitlab_replication" {
  name        = "mhe_gitlab_replication"
  description = "Allow replication traffic between gitlab subnets"
  vpc_id      = "${var.deployment_vpc_id}"

  ingress {
    from_port = 1194
    to_port   = 1194
    protocol  = "udp"

    cidr_blocks = [
      "${data.aws_subnet.zone_a.cidr_block}",
      "${data.aws_subnet.zone_b.cidr_block}",
    ]
  }

  tags {
    Name = "mhe_gitlab_replication"
  }
}
