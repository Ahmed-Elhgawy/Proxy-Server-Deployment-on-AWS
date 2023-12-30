# Bastion Server Security Group ====================================================
resource "aws_security_group" "bastion-sg" {
  name        = "Bastion-SG"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow SSH from any"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "Bastion-SG"
  }
}

# Application LoadBalancer Security Group ==========================================
resource "aws_security_group" "alb-sg" {
  name        = "ALB-SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow HTTP from any"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "ALB-SG"
  }
}

# Frontend Security Group ==========================================================
resource "aws_security_group" "frontend-sg" {
  name        = "Frontend-SG"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow HTTP from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ aws_security_group.alb-sg.id ]
  }

  ingress {
    description      = "Allow SSH from Bastion server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "Frontend-SG"
  }
}

# Network LoadBalancer Security Group ==========================================
resource "aws_security_group" "nlb-sg" {
  name        = "NLB-SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow HTTP from Frontend"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ aws_security_group.frontend-sg.id ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "NLB-SG"
  }
}

# Backend Security Group ==========================================================
resource "aws_security_group" "backend-sg" {
  name        = "Backend-SG"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "Allow HTTP from NLB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ aws_security_group.nlb-sg.id ]
  }

  ingress {
    description      = "Allow SSH from Bastion server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "Backend-SG"
  }
}
