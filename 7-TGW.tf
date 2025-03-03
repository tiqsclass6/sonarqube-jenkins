# 4. Build the Transit Gateway

resource "aws_ec2_transit_gateway" "Brazil-TGW01" {
  description = "Brazil-TGW01"

  tags = {
    Name     = "Brazil-TGW01"
    Service  = "TGW"
    Location = "Sao Paulo"
    Owner    = "TIQS"
  }
}