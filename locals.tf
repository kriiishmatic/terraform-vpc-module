locals {
  common_tags = {
    Environment = "Testing"
    Project     = "TerraformVPC"
    Owner       = "krish" 
  }
  common_name = "${var.project_name}-${var.environment}"
  av_names = slice(data.aws_availability_zones.available.names,0,2)
}


