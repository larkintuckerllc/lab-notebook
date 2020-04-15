resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.identifier
  }
}

resource "aws_subnet" "s0" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.identifier}-s0"
    Tier = "Public"
  }
  vpc_id                  = aws_vpc.this.id
}

resource "aws_subnet" "s1" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.identifier}-s1"
    Tier = "Public"
  }
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "s2" {
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.identifier}-s2"
    Tier = "Public"
  }
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "s10" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.10.0/24"
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    Name = "${var.identifier}-s10"
    Tier = "Private"
  }
  vpc_id                  = aws_vpc.this.id
}

resource "aws_subnet" "s11" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.11.0/24"
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    Name = "${var.identifier}-s11"
    Tier = "Private"
  }
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "s12" {
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.12.0/24"
  tags = {
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    Name = "${var.identifier}-s12"
    Tier = "Private"
  }
  vpc_id            = aws_vpc.this.id
}

resource "aws_internet_gateway" "this" {
  tags = {
    Name = var.identifier
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "s0" {
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name = "${var.identifier}-s0"
  }
  vpc = true
}

resource "aws_eip" "s1" {
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name = "${var.identifier}-s1"
  }
  vpc = true
}

resource "aws_eip" "s2" {
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name = "${var.identifier}-s2"
  }
  vpc = true
}

resource "aws_nat_gateway" "s0" {
  allocation_id = aws_eip.s0.id
  subnet_id     = aws_subnet.s0.id
  tags = {
    Name = "${var.identifier}-s0"
  }
}

resource "aws_nat_gateway" "s1" {
  allocation_id = aws_eip.s1.id
  subnet_id     = aws_subnet.s1.id
  tags = {
    Name = "${var.identifier}-s1"
  }
}

resource "aws_nat_gateway" "s2" {
  allocation_id = aws_eip.s2.id
  subnet_id     = aws_subnet.s2.id
  tags = {
    Name = "${var.identifier}-s2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.identifier}-public"
  }
}

resource "aws_route_table_association" "s0" {
  subnet_id      = aws_subnet.s0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "s1" {
  subnet_id      = aws_subnet.s1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "s2" {
  subnet_id      = aws_subnet.s2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "s10" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.s0.id
  }
  tags = {
    Name = "${var.identifier}-s10"
  }
}

resource "aws_route_table" "s11" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.s1.id
  }
  tags = {
    Name = "${var.identifier}-s11"
  }
}

resource "aws_route_table" "s12" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.s2.id
  }
  tags = {
    Name = "${var.identifier}-s12"
  }
}

resource "aws_route_table_association" "s10" {
  subnet_id      = aws_subnet.s10.id
  route_table_id = aws_route_table.s10.id
}

resource "aws_route_table_association" "s11" {
  subnet_id      = aws_subnet.s11.id
  route_table_id = aws_route_table.s11.id
}

resource "aws_route_table_association" "s12" {
  subnet_id      = aws_subnet.s12.id
  route_table_id = aws_route_table.s12.id
}

resource "aws_network_acl" "public" {
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = [
    aws_subnet.s0.id,
    aws_subnet.s1.id,
    aws_subnet.s2.id
  ] 
  tags = {
    Name = "${var.identifier}-public"
  }
  vpc_id     = aws_vpc.this.id
}

resource "aws_network_acl" "private" {
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "udp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = aws_vpc.this.cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = [
    aws_subnet.s10.id,
    aws_subnet.s11.id,
    aws_subnet.s12.id
  ] 
  tags = {
    Name = "${var.identifier}-private"
  }
  vpc_id     = aws_vpc.this.id
}

resource "aws_security_group" "bastion" {
  name   = "${var.identifier}-bastion"
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group_rule" "bastion_ingress_all" {
  from_port         = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id = aws_security_group.bastion.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion.id
  to_port           = 0
  type              = "egress"
}
