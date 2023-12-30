# Providor =========================================================================
provider "aws" {
  region = var.region
}

# Network ==========================================================================
module "network" {
  source = "./modules/network"

  cidr = var.cidr
  azs = var.azs
}

# Security =========================================================================
module "security" {
  source = "./modules/security"

  vpc-id = module.network.vpc-id
}

# Instances ========================================================================
# Frontend instances ------------------------------------------------------
resource "aws_instance" "frontend-servers" {
  count = length(var.azs)
  ami                     = var.instance-ami
  instance_type           = var.instance-type
  security_groups = [ module.security.frontend-sg-id ]
  subnet_id = module.network.public-subnets-id[count.index]
  key_name = var.key-pair

  tags = {
    Name = "Frontend-Server-${count.index+1}"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ./ansible/frontend_ips.tmp"
  }
}

# Backend instances ------------------------------------------------------
resource "aws_instance" "backend-servers" {
  count = length(var.azs)
  ami                     = var.instance-ami
  instance_type           = var.instance-type
  security_groups = [ module.security.backend-sg-id ]
  subnet_id = module.network.private-subnets-id[count.index]
  key_name = var.key-pair

  tags = {
    Name = "Backend-Server-${count.index+1}"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ./ansible/backend_ips.tmp"
  }
}
# Bastion instance ------------------------------------------------------
resource "aws_instance" "bastion-server" {
  ami                     = var.instance-ami
  instance_type           = var.instance-type
  security_groups = [ module.security.bastion-sg-id ]
  subnet_id = module.network.public-subnets-id[0]
  key_name = var.key-pair

  tags = {
    Name = "Bastion-Server"
  }

  provisioner "local-exec" {
    command = "sed -i s/BASTION_IP/${self.public_ip}/g ./ansible/template/ssh_config"
  }
}

# Load Balancer ====================================================================
module "load-balancer" {
  source = "./modules/load-balancer"

  alb-sg = [ module.security.alb-sg-id ]
  nlb-sg = [ module.security.nlb-sg-id ]

  alb-subnets = module.network.public-subnets-id
  nlb-subnets = module.network.private-subnets-id

  vpc-id = module.network.vpc-id
  azs = var.azs

  frontend-instaces-id = [ for i in aws_instance.frontend-servers : i.id ]
  backend-instaces-id = [ for i in aws_instance.backend-servers : i.id ]
}
