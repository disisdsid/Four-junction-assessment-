provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "ionginx_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ionginx-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = 3
  vpc_id            = aws_vpc.ionginx_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.ionginx_vpc.cidr_block, 3, count)
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = 3
  vpc_id            = aws_vpc.ionginx_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.ionginx_vpc.cidr_block, 3, count + 3)
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ionginx_vpc.id
  tags = {
    Name = "ionginx-igw"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = "ionginx-nat-gateway"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "ionginx-nat-eip"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ionginx_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "ionginx-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.ionginx_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "ionginx-private-rt"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = 3
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  count          = 3
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

data "aws_availability_zones" "available" {}
