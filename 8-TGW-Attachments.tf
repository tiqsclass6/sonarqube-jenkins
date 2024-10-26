# 5. Insert Transit Gateway (TGW) Attachments to the TGW

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC-A-SaoPaulo-Prod-TGW-Attachment" {
  subnet_ids         = [aws_subnet.vpc-A-public-sa-east-1a.id]
  transit_gateway_id = aws_ec2_transit_gateway.Brazil-TGW01.id
  vpc_id             = aws_vpc.VPC-A-SaoPaulo-Prod.id

  tags = {
    Name = "VPC-A-SaoPaulo-Prod-TGW-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC-B-SaoPaulo-Dev-TGW-Attachment" {
  subnet_ids         = [aws_subnet.vpc-B-private-sa-east-1b.id]
  transit_gateway_id = aws_ec2_transit_gateway.Brazil-TGW01.id
  vpc_id             = aws_vpc.VPC-B-SaoPaulo-Dev.id

  tags = {
    Name = "VPC-B-SaoPaulo-Dev-TGW-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC-C-SaoPaulo-Test-TGW-Attachment" {
  subnet_ids            = [aws_subnet.vpc-C-private-sa-east-1c.id]
  transit_gateway_id    = aws_ec2_transit_gateway.Brazil-TGW01.id
  vpc_id                = aws_vpc.VPC-C-SaoPaulo-Test.id

  tags = {
    Name                = "VPC-C-SaoPaulo-Test-TGW-Attachment"
  }
}