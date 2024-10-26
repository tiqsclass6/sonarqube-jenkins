# 3. Build the Route Tables. One Public and Three Private

resource "aws_route_table" "VPC-A-SaoPaulo-Prod-PublicRT" {
  vpc_id = aws_vpc.VPC-A-SaoPaulo-Prod.id

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.Brazil-TGW01.id
    }

  tags = {
    Name = "VPC-A-SaoPaulo-Prod-PublicRT"
  }
}

resource "aws_route_table" "VPC-A-SaoPaulo-Prod-PrivateRT" {
  vpc_id = aws_vpc.VPC-A-SaoPaulo-Prod.id

  tags = {
    Name = "VPC-A-SaoPaulo-Prod-PrivateRT"
  }
}

resource "aws_route_table" "VPC-B-SaoPaulo-Dev-PrivateRT" {
  vpc_id = aws_vpc.VPC-B-SaoPaulo-Dev.id

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.Brazil-TGW01.id
    }

  tags = {
    Name = "VPC-B-SaoPaulo-Dev-PrivateRT"
  }
}

resource "aws_route_table" "VPC-C-SaoPaulo-Test-PrivateRT" {
  vpc_id = aws_vpc.VPC-C-SaoPaulo-Test.id

  tags = {
    Name = "VPC-C-SaoPaulo-Test-PrivateRT"
  }
}