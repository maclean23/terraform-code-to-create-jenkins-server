# vpc.tf

# VPC Resource
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block  # e.g., "10.0.0.0/16"
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# Subnet Resource
resource "aws_subnet" "myapp_subnet_1" {
  vpc_id                  = aws_vpc.myapp_vpc.id
  cidr_block              = var.subnet_cidr_block  # e.g., "10.0.1.0/24"
  availability_zone       = var.avail_zone
  map_public_ip_on_launch = true  # Ensure this is set to true
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

# Internet Gateway Resource
resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = aws_vpc.myapp_vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# Route Table Resource
resource "aws_route_table" "main_rtb" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Route all traffic to the internet
    gateway_id = aws_internet_gateway.myapp_igw.id
  }

  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

# Route Table Association Resource
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.myapp_subnet_1.id
  route_table_id = aws_route_table.main_rtb.id
}

# Default Security Group Resource
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.myapp_vpc.id  # Corrected reference to VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

# Additional Security Group Resource
resource "aws_security_group" "app_sg" {
  name        = "${var.env_prefix}-app-sg"
  description = "Security group for my app"
  vpc_id      = aws_vpc.myapp_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
        description = "HTTPS traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "${var.env_prefix}-app-sg"
  }
}
