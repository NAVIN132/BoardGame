module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "boardgame-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "boardgame-sg"
  description = "Allow HTTP, HTTPS, SSH"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("C:/KCSWorks/DevOps/CapstoneProject/.ssh/appserverkey.pub")
}