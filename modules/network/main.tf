# VPC ==============================================================================
resource "aws_vpc" "web-vpc" {
  cidr_block       = var.cidr

  tags = {
    Name = "web-vpc"
  }
}

# Subnets ==========================================================================
# Public Subnets ----------------------------------------------------------
resource "aws_subnet" "public-subnets" {
  count = length(var.azs)
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = cidrsubnet(var.cidr, 8, count.index+1)
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-${count.index+1}"
  }
}

# Private Subnets ---------------------------------------------------------
resource "aws_subnet" "private-subnets" {
  count = length(var.azs)
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = cidrsubnet(var.cidr, 8, count.index+101)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Private-Subnet-${count.index+1}"
  }
}

# Internet Gateway =================================================================
resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web-vpc.id

  tags = {
    Name = "Web-GW"
  }
}

# Nat Gateway ======================================================================
# Elastic IP -------------------------------------------------------------
resource "aws_eip" "web-ip" {
  domain           = "vpc"

  tags = {
    Name = "Web-IP"
  }
}

resource "aws_nat_gateway" "web-nat" {
  allocation_id = aws_eip.web-ip.id
  subnet_id     = aws_subnet.public-subnets[0].id

  tags = {
    Name = "Web-NAT"
  }

  depends_on = [ aws_internet_gateway.web-gw ]
}

# Route Tables =====================================================================
# Public Route Table -----------------------------------------------------
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.web-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-gw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

# Private Route Table ----------------------------------------------------
resource "aws_default_route_table" "private-rt" {
  default_route_table_id = aws_vpc.web-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web-nat.id
  }

  tags = {
    Name = "Private-RT"
  }
}

# Public RT Association --------------------------------------------------
resource "aws_route_table_association" "public-rt-association" {
  count = length(var.azs)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

# Private RT Association --------------------------------------------------
resource "aws_route_table_association" "private-rt-association" {
  count = length(var.azs)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_default_route_table.private-rt.id
}
