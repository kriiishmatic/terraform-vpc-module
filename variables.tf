variable "vpc_cidr_block" {
  description = "vpc cidr"
  type = string
}

variable "vpc_tags" {
  type = map
  default = {}
}

variable "igw_tags" {
  type = map
  default = {}
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc-public-subnet-cidr" {
  description = "public subnet cidr 1a"
  type = list 
}

variable "vpc-private-subnet-cidr" {
  description = "private subnet cidr"
  type = list
}

variable "vpc-database-subnet-cidr" {
  description = "database subnet cidr "
  type = list
}

variable "public_subnet_tags" {
  description = "Only useful tags"
  type = map
  default = {}
}

variable "private_subnet_tags" {
  description = "Only useful tags"
  type = map
  default = {}
}

variable "database_subnet_tags" {
  description = "Only useful tags"
  type = map
  default = {}
}

variable "nat_tags" {
  description = "nat using eip"
  type = map
  default = {}
}

variable "eip_tags" {
  description = "eip tags"
  type = map
  default = {}
}

variable "is_peering_enabled" {
  type = bool
  default = true
}
