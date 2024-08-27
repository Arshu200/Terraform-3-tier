# <---------------Creating the VPC----------------->
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "application-vpc"
  }
}

# <--------------------creating the publicSubnet1 ------------->
resource "aws_subnet" "publicSubnet1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "application-public-subet-1a"
  }
}

# <--------------------creating the publicSubnet2 ------------->
resource "aws_subnet" "publicSubnet2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "application-public-subet-2a"
  }
}

# <--------------------creating the privateSubnet1 ------------->
resource "aws_subnet" "privateSubnet1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "application-private-subet-1a"
  }
}

# <--------------------creating the privateSubnet2 ------------->
resource "aws_subnet" "privateSubnet2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.4.0/24"
  tags = {
    Name = "application-public-subet-2a"
  }
}


# <-----------Creating the IGW----------->
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "application Internetgateway"
  }
}

# <-----------Creating the publicRoutable------------>

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

# <------------Associating the publicsubnets to the route table-------------->
resource "aws_route_table_association" "rtb-ac-1" {
  subnet_id      = aws_subnet.publicSubnet1.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "rtb-ac-2" {
  subnet_id      = aws_subnet.publicSubnet2.id
  route_table_id = aws_route_table.public-rtb.id
}

# <---------------Creating Elastic IP --------------------------------->
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "application-vpc-eip"
  }
}

# <-----------Creating the NAT GateWay------------>
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  # subnet_id     = aws_subnet.privateSubnet2.id
  subnet_id = aws_subnet.publicSubnet1.id
  tags = {
    Name = "application-vpc-nat"
  }
}

# <-----------------Creating the Private Rtb ------------------------>
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Private Route Table"
  }
}


# <-------------Associating the private subnet-1 with the route-table---------->
resource "aws_route_table_association" "rtb-asc-private-subnet1" {
  route_table_id = aws_route_table.private-rtb.id
  subnet_id      = aws_subnet.privateSubnet1.id
}

# <-------------Associating the private subnet-2 with the route-table---------->
resource "aws_route_table_association" "rtb-asc-private-subnet2" {
  route_table_id = aws_route_table.private-rtb.id
  subnet_id      = aws_subnet.privateSubnet2.id
}


# <----------------Creating the Bastion Security Groups ----------------->
resource "aws_security_group" "Bastion-SG" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Application Bastion SG"
  description = "This Security for the applications bastion-host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing the SSH to our instance"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing the outbound to our instance"
  }

  tags = {
    Name = "Application Bastion SG"
  }
}

# <----------------Creating the Private Security Groups ----------------->
resource "aws_security_group" "Private-SG" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Application Private SG"
  description = "This Security for the applications"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.Bastion-SG.id]
    description     = "Allowing the SSH to our instance"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.Bastion-SG.id]
    description = "Allowing the HTTP Traffic to our instance"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing the HTTP traffic to our instance"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing the outbound to our instance"
  }

  tags = {
    Name = "Application Private SG"
  }
}

# <----------------Creating the Private Security Groups ----------------->
resource "aws_security_group" "ALB-SG" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Application ALB SG"
  description = "This Security for the applications"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing the HTTP traffic to our instance"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing the outbound to our instance"
  }

  tags = {
    Name = "Application ALB SG"
  }
}

