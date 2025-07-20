variable "vpc_id" {default = "10.100.0.0/16"}
variable "subnet_ids" { 
    type = list(string) 
    default = ["10.100.3.0/24", "10.100.200.0/24"]
}
variable "key_name" {default = "admin"}
variable "instance_type" { default = "t2.micro" }
variable "db_username" {default = "navink"}
variable "db_password" { default = "root1234" }