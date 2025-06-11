data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "terraform-agro-cicd" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc
  }
}


# Subnet
resource "aws_subnet" "tac_public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.terraform-agro-cicd.id
  cidr_block              = cidrsubnet(aws_vpc.terraform-agro-cicd.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tac_public_subnet}-pub-subnet-${count.index}"
  }
}


# IGW
resource "aws_internet_gateway" "tac-igw" {
  vpc_id = aws_vpc.terraform-agro-cicd.id


  tags = {
    Name = "${var.vpc}-igw"
  }
}


# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform-agro-cicd.id

  route {
    cidr_block = var.rt_cidr
    gateway_id = aws_internet_gateway.tac-igw.id
  }

  tags = {
    Name = "${var.vpc}-route-table"
  }
}


# RT Assoc
resource "aws_route_table_association" "tac-tr_assoc" {
  count          = 2
  subnet_id      = aws_subnet.tac_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public.id
}
