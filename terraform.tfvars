region              = "us-east-1"
infra_env           = "dev"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.0.0/24"

private_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

az       = "us-east-1a"
az_list  = ["us-east-1a", "us-east-1b"]

instance_type       = "t3.micro"

rds_instance_class  = "db.t3.micro"
rds_username        = "adminuser"
rds_password        = "ChangeMe123!"
