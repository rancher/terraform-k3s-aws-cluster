resource "random_pet" "lb" {}

resource "aws_lb" "server-lb" {
  name               = substr("${local.name}-int-${random_pet.lb.id}", 0, 24)
  internal           = true
  load_balancer_type = "network"
  subnets            = local.private_subnets
}

resource "aws_lb_listener" "server-port_6443" {
  load_balancer_arn = aws_lb.server-lb.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-6443.arn
  }
}

resource "aws_lb_target_group" "server-6443" {
  name     = substr("${local.name}-6443-${random_pet.lb.id}", 0, 24)
  port     = 6443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
}


resource "aws_lb" "lb" {
  count              = local.create_external_nlb
  name               = substr("${local.name}-ext-${random_pet.lb.id}", 0, 24)
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}

resource "aws_lb_listener" "port_443" {
  count             = local.create_external_nlb
  load_balancer_arn = aws_lb.lb.0.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-443.0.arn
  }
}

resource "aws_lb_listener" "port_80" {
  count             = local.create_external_nlb
  load_balancer_arn = aws_lb.lb.0.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-80.0.arn
  }
}

resource "aws_lb_target_group" "agent-443" {
  count    = local.create_external_nlb
  name     = substr("${local.name}-443-${random_pet.lb.id}", 0, 24)
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}

resource "aws_lb_target_group" "agent-80" {
  count    = local.create_external_nlb
  name     = substr("${local.name}-80-${random_pet.lb.id}", 0, 24)
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}
