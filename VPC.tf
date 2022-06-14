//Creating VPC for our project
resource "aws_vpc" "my_vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = "Complex project VPC."
    Project = var.project_name
  }
}

//Creating Internet gateway for our VPC
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Complex project IGW."
    Project = var.project_name
  }
}

//Creating public subnet
resource "aws_subnet" "public_subnet_1" {
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Complex public subnet 1."
    Project = var.project_name
  }
}


resource "aws_subnet" "public_subnet_2" {
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_cidr1
  map_public_ip_on_launch = true
  tags = {
    Name = "Complex public subnet 2."
    Project = var.project_name
  }
}
//Public subnet routing table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
  }
  tags = {
    Name = "Complex public routing table."
    Project = var.project_name
  }
}

//routing table association
resource "aws_route_table_association" "public_assoc_1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_assoc_2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet_2.id
}


//Creating private subnet
resource "aws_subnet" "private_subnet_1" {
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "Complex private subnet."
    Project = var.project_name
  }
}

resource "aws_subnet" "private_subnet_2" {
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_cidr1
  map_public_ip_on_launch = false
  tags = {
    Name = "Complex private subnet1."
    Project = var.project_name
  }
}



resource "aws_eip" "EIP_NAT_1" {
  vpc = true
  tags = {
    Name = "EIP for NAT_1"
    Project = var.project_name
  }
}
resource "aws_nat_gateway" "NAT_gateway_1" {
  allocation_id = aws_eip.EIP_NAT_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_route_table" "private_1_rout_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_gateway_1.id
  }
  tags = {
    Name = "Route table nat1"
    Project = var.project_name
  }
}



resource "aws_route_table_association" "private_1_to_NAT_1" {
  route_table_id = aws_route_table.private_1_rout_table.id
  subnet_id      = aws_subnet.private_subnet_1.id
}






resource "aws_eip" "EIP_NAT_2" {
  vpc = true
  tags = {
    Name = "EIP for NAT_1"
    Project = var.project_name
  }
}

resource "aws_nat_gateway" "NAT_gateway_2" {
allocation_id = aws_eip.EIP_NAT_2.id
subnet_id     = aws_subnet.public_subnet_2.id
}


resource "aws_route_table" "private_2_rout_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_gateway_2.id
  }
  tags = {
    Name = "private subnet2 route table"
    Project = var.project_name
  }
}


resource "aws_route_table_association" "private_2_to_NAT_2" {
  route_table_id = aws_route_table.private_2_rout_table.id
  subnet_id      = aws_subnet.private_subnet_2.id
}

