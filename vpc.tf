# PART 1
provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "default" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "interview vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_egress_only_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "eu-west-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "eu-west-1b-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block        = "10.1.0.0/24"
  availability_zone = "eu-west-1b"
}

resource "aws_route_table" "eu-west-1-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "eu-west-1-public-a" {
  subnet_id      = "${aws_subnet.eu-west-1a-public.id}"
  route_table_id = "${aws_route_table.eu-west-1-public.id}"
}

resource "aws_route_table_association" "eu-west-1-public-b" {
  subnet_id      = "${aws_subnet.eu-west-1b-public.id}"
  route_table_id = "${aws_route_table.eu-west-1-public.id}"
}


resource "aws_nat_gateway" "gw" {
  allocation_id = ""
  subnet_id     = ""
}

/*
  Private Subnet
*/
resource "aws_subnet" "eu-west-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block        = "10.2.0.0/24"
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "eu-west-1b-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block        = "10.3.0.0/24"
  availability_zone = "eu-west-1b"
}


resource "aws_route" "igw-route" {
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.default.id}"
  route_table_id              = "${aws_route_table.eu-west-1-private.id}"
  depends_on                  = ["aws_route_table.eu-west-1-private"]
}

resource "aws_route" "nat-route" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw.id}"
  route_table_id         = "${aws_route_table.eu-west-1-private.id}"
  depends_on             = ["aws_route_table.eu-west-1-private"]
}

resource "aws_route_table_association" "eu-west-1-private-a" {
  subnet_id      = "${aws_subnet.eu-west-1a-private.id}"
  route_table_id = "${aws_route_table.eu-west-1-private.id}"
}

resource "aws_route_table_association" "eu-west-1-private-b" {
  subnet_id      = "${aws_subnet.eu-west-1b-private.id}"
  route_table_id = "${aws_route_table.eu-west-1-private.id}"
}

/*
  Default security group
*/
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}
