data "aws_subnets" "main" {
  filter {
    name   = "tag:Name"
    values = var.subnet_names
  }
}

data "aws_subnet" "for_vpc" {
  id = data.aws_subnets.main.ids[0]
}

data "aws_vpc" "main" {
  id = data.aws_subnet.for_vpc.vpc_id
}

data "aws_route53_zone" "main" {
  name = var.zone_name
}
