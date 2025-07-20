resource "aws_lb" "boardgame_alb" {
  name               = "boardgame-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-12345", "subnet-67890"]
}