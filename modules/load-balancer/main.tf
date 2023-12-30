# Application LoadBalancer =========================================================
# ALB --------------------------------------------------------------------
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb-sg
  subnets            = var.alb-subnets

  tags = {
    Name = "ALB"
  }
}

# ALB Target Group -------------------------------------------------------
resource "aws_lb_target_group" "alb-tg" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  tags = {
    Name = "ALB-TG"
  }
}
# ALB Target Group Attachment --------------------------------------------
resource "aws_lb_target_group_attachment" "alb-tg-attachment" {
  count = length(var.azs)
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = var.frontend-instaces-id[count.index]
  port             = 80
}

# ALB Listener -----------------------------------------------------------
resource "aws_lb_listener" "frontend-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

# Network LoadBalancer =============================================================
# NLB --------------------------------------------------------------------
resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups = var.nlb-sg
  subnets            = var.nlb-subnets

  tags = {
    Name = "NLB"
  }
}

# NLB Target Group -------------------------------------------------------
resource "aws_lb_target_group" "nlb-tg" {
  name     = "nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc-id

  tags = {
    Name = "NLB-TG"
  }
}
# NLB Target Group Attachment --------------------------------------------
resource "aws_lb_target_group_attachment" "nlb-tg-attachment" {
  count = length(var.azs)
  target_group_arn = aws_lb_target_group.nlb-tg.arn
  target_id        = var.backend-instaces-id[count.index]
  port             = 80
}

# NLB Listener -----------------------------------------------------------
resource "aws_lb_listener" "backend-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}
