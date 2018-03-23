resource "aws_elb" "mhe-gitlab-elb" {
  name = "mhe-gitlab-elb"

  subnets = [
    "${data.aws_subnet.zone_a.id}",
    "${data.aws_subnet.zone_b.id}",
  ]

  security_groups = [
    "${aws_security_group.internet_gitlab_service.id}",
  ]

  listener {
    instance_port     = 443
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 22
    instance_protocol = "ssl"
    lb_port           = 8022  # TODO: This probably needs to be an ALB. You can't do port 22 with ELB.
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 10
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "mhe-gitlab-elb"
  }
}
