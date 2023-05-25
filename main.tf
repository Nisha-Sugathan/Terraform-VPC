#  VPC resource block

resource "aws_vpc" "main" {

  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-${var.project_enivornment}"
  }
}

# IGW resource block
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.project_enivornment}"
  }
}

# Creating 3 public subnets

resource "aws_subnet" "public" {
  count = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr,3,count.index) 
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-${var.project_enivornment}-public- ${ count.index +1 }"
  }
}

# Creating 3 private subnet

resource "aws_subnet" "private" {
  count = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr,3,count.index + 3) 
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-${var.project_enivornment}-private- ${ count.index +1 }"
  }
}

# Elastic IP for NAT gateway

resource "aws_eip" "nat" {
 count = var.create_nat == true ? 1 :0
  vpc      = true
   tags = {
    Name = "${var.project_name}-${var.project_enivornment}-nat"
  }
}



#  NAT gateway
resource "aws_nat_gateway" "nat" {

count = var.create_nat == true ? 1 :0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-${var.project_enivornment}"
  }

 
  depends_on = [aws_internet_gateway.igw]
}


# Creating routing table for public traffic

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  
  tags = {
    Name = "${var.project_name}-${var.project_enivornment}-public"
  }
}

# Creating routing table for private traffic

resource "aws_route_table" "private_nat_enabled" {
count = var.create_nat == true ? 1 :0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  
  tags = {
    Name = "${var.project_name}-${var.project_enivornment}-private"
  }
}


resource "aws_route_table" "private_nat_disabled" {
count = var.create_nat == false ? 1 : 0
  vpc_id = aws_vpc.main.id
   tags = {
    Name = "${var.project_name}-${var.project_enivornment}-private_local"
  }

}

# Associating 3 Public route table

resource "aws_route_table_association" "public" {
count = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}



#  Associating 3 Private route table

resource "aws_route_table_association" "private" {
count = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_nat_enabled[0].id
}



