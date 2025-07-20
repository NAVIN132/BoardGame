resource "aws_instance" "web" {
  ami                    = "ami-0a1235697f4afa8a4" # Amazon Linux 2023
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.sg.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "boardgame-webapp-instance"
  }
}