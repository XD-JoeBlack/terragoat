# Create a new load balancer
resource "aws_elb" "weblb" {
  name = "weblb-terraform-elb"

  # --- HTTPS listener (fix) ---
  listener {
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = 8000
    instance_protocol  = "http"
    ssl_certificate_id = var.acm_certificate_arn
  }

  # If you MUST keep port 80 temporarily, leave the block below;
  # otherwise delete it to satisfy rules that forbid plain HTTP.
  # listener {
  #   lb_port           = 80
  #   lb_protocol       = "http"
  #   instance_port     = 8000
  #   instance_protocol = "http"
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  subnets                     = [aws_subnet.web_subnet.id]
  security_groups             = [aws_security_group.web-node.id]
  instances                   = [aws_instance.web_host.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = merge({
    Name = "foobar-terraform-elb"
  }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/elb.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "b4a83ce9-9a45-43b4-b6d9-1783c282f702"
  })
}
