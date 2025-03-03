# 1. Setup the three (3) Virtual Private Clouds (VPC)

resource "aws_vpc" "VPC-A-SaoPaulo-Prod" {
  cidr_block = "10.230.0.0/16"

  tags = {
    Name     = "VPC-A-SaoPaulo-Prod"
    Service  = "VPC"
    Location = "Sao Paulo"
    Owner    = "TIQS"
  }
}

resource "aws_vpc" "VPC-B-SaoPaulo-Dev" {
  cidr_block = "10.231.0.0/16"

  tags = {
    Name     = "VPC-B-SaoPaulo-Dev"
    Service  = "VPC"
    Location = "Sao Paulo"
    Owner    = "TIQS"
  }
}

resource "aws_vpc" "VPC-C-SaoPaulo-Test" {
  cidr_block = "10.232.0.0/16"

  tags = {
    Name     = "VPC-C-SaoPaulo-Test"
    Service  = "VPC"
    Location = "Sao Paulo"
    Owner    = "TIQS"
  }
}