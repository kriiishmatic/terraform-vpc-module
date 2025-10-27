#Vpc-peering
resource "aws_vpc_peering_connection" "peer" {
  count         = var.is_peering_enabled ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
  tags = merge(
    local.common_tags,
    {
      Name = "${local.common_name}-peer"
    },
    
  )
}

#Peering routes
resource "aws_route" "public-to-peer" {
  count                  = var.is_peering_enabled ? 1 : 0
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}

#peerig routes from deault to vpc main

resource "aws_route" "default-to-main" {
  count                  = var.is_peering_enabled ? 1 : 0
  route_table_id         = data.aws_route_table.default_vpc_rt.id
  destination_cidr_block = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}

