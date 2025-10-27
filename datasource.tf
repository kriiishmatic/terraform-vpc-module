data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpv" "default" {
  default = true 
}
data "aws_vpc" "default" {
  default = true 
}

data "aws_default_route_table" "default_vpc_rt" {
  vpc_id = data.aws_vpc.default.id
  default = true
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

