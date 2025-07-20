resource "aws_db_instance" "boardgame_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.boardgame_subnet_group.name
  vpc_security_group_ids = [module.sg.security_group_id]
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "boardgame_subnet_group" {
  name       = "boardgame-subnet-group"
  subnet_ids = module.vpc.private_subnets
}