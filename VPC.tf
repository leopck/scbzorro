resource "aws_vpc" "app_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "app_vpc" {
  map_public_ip_on_launch = true
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-southeast-2a" 

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "app_vpc_2" {
  map_public_ip_on_launch = true
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = "ap-southeast-2b" 

  tags = {
    Name = "tf-example"
  }
}