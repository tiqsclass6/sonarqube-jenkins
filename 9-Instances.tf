# 8. Create EC2 Instances

resource "aws_instance" "VPC-A-SaoPaulo-Prod-Windows" {
  ami                   = "ami-0c3d216834405c1db"
  instance_type         = "t2.medium"
  subnet_id             = aws_subnet.vpc-A-public-sa-east-1a.id
  vpc_security_group_ids = [aws_security_group.VPC-A-SaoPaulo-Prod-With-Bastion-01.id]

  tags = {
    Name                = "VPC-A-SaoPaulo-Prod-Windows"
    service             = "windows"
  }
}

resource "aws_instance" "VPC-B-SaoPaulo-Dev-basiclinux" {
  ami                   = "ami-0989c1b438266c944"
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.vpc-A-public-sa-east-1a.id
  vpc_security_group_ids = [aws_security_group.VPC-A-SaoPaulo-Prod-With-Bastion-01.id]

  tags = {
    Name                = "VPC-B-SaoPaulo-Dev-basiclinux"
    service             = "basiclinux"
  }
}
