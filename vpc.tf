#VPC Module
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = merge(
    local.common_tags,
    var.vpc_tags,
    {
      Name = local.common_name
    },
    
  )
}
#Internet Gateway   
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    var.igw_tags,
    {
      Name = "${local.common_name}-igw"
    },
    
  )
} 
#Subnets public
resource "aws_subnet" "public" {
  count = length(var.vpc-public-subnet-cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc-public-subnet-cidr[count.index]
  availability_zone = local.av_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.common_name}-public-subnet-${local.av_names[count.index]}"
    },
    
  )
}
#Subnets private
resource "aws_subnet" "private" {
  count = length(var.vpc-private-subnet-cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc-private-subnet-cidr[count.index]
  availability_zone = local.av_names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    local.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.common_name}-private-subnet-${local.av_names[count.index]}"
    },
    
  )
}
#Subnets database
resource "aws_subnet" "database" {
  count = length(var.vpc-database-subnet-cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc-database-subnet-cidr[count.index]
  availability_zone = local.av_names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    local.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.common_name}-database-subnet-${local.av_names[count.index]}"
    },
    
  )
}
#route table public
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-public-rt"
    },
    
  )
}
#route table private
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-private-rt"
    },
    
  )
}
#route table database
resource "aws_route_table" "database-rt" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-database-rt"
    },
    
  )
}
#Route public
resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

#Route private
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}
#Route database
resource "aws_route" "database-route" {
  route_table_id         = aws_route_table.database-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}
#Subnet association public
resource "aws_route_table_association" "public-rt-assoc" {
  count          = length(var.vpc-public-subnet-cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}
#Subnet association private
resource "aws_route_table_association" "private-rt-assoc" {
  count          = length(var.vpc-private-subnet-cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
#Subnet association database
resource "aws_route_table_association" "database-rt-assoc" {
  count          = length(var.vpc-database-subnet-cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database-rt.id
} 
#Elastic IP for NAT Gateway
resource "aws_eip" "nat-eip" {
  domain = "vpc"
  tags = merge(
    local.common_tags,
    var.eip_tags,
    {
      Name = "${local.common_name}-nat-eip"
    },
    
  )
}
#NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    local.common_tags,
    var.nat_tags,
    {
      Name = "${local.common_name}-nat-gw"
    },
    
  )
  depends_on = [aws_internet_gateway.main]
}


