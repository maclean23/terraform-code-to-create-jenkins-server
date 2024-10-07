# main.tf

# Data source for the latest Ubuntu AMI
data "aws_ami" "latest_ubuntu_linux_image" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance Resource
resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.latest_ubuntu_linux_image.id
  instance_type         = "t2.small"  # Choose your instance type
  subnet_id             = aws_subnet.myapp_subnet_1.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]  # Use the correct security group
  associate_public_ip_address = true  # Ensure the instance gets a public IP
  user_data             = file("jenkins-server-script.sh")  # Ensure your script is in the correct path

  tags = {
    Name = "${var.env_prefix}-jenkins-server"  # Use the environment prefix for tagging
  }
}
