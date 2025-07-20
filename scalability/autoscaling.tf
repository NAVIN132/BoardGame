resource "aws_autoscaling_group" "boardgame_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = ["10.100.3.0/24", "10.100.200.0/24"]

  launch_configuration = aws_launch_configuration.boardgame_lc.name
}

resource "aws_launch_configuration" "boardgame_lc" {
  name          = "boardgame-webapp-instance"
  image_id      = "ami-0a1235697f4afa8a4"
  instance_type = "t3.micro"
  key_name      = "admin"
}