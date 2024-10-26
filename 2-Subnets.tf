# 2. Setup the four (4) Subnets. One Public and Three Privates

resource "aws_subnet" "vpc-A-public-sa-east-1a" {
  vpc_id                  = aws_vpc.VPC-A-SaoPaulo-Prod.id
  cidr_block              = "10.230.1.0/24"
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "vpc-A-private-sa-east-1a" {
  vpc_id                  = aws_vpc.VPC-A-SaoPaulo-Prod.id
  cidr_block              = "10.230.11.0/24"
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "vpc-B-private-sa-east-1b" {
  vpc_id                  = aws_vpc.VPC-B-SaoPaulo-Dev.id
  cidr_block              = "10.231.11.0/24"
  availability_zone       = "sa-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "vpc-C-private-sa-east-1c" {
  vpc_id                  = aws_vpc.VPC-C-SaoPaulo-Test.id
  cidr_block              = "10.232.11.0/24"
  availability_zone       = "sa-east-1c"
  map_public_ip_on_launch = true
}