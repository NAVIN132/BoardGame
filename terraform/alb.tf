resource "aws_lb" "boardgame_alb" {
  name               = "boardgame-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.sg.security_group_id]
}

resource "aws_lb_target_group" "boardgame_tg" {
  name     = "boardgame-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.boardgame_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.boardgame_tg.arn
  }
}