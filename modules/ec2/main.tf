# Generate SSH Key

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}

# Save Private Key Locally

resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = "${var.key_name}.pem"
}

# IAM Instance Profile

resource "aws_iam_instance_profile" "this" {
  name = "${var.instance_name}-profile"
  role = var.iam_instance_role
}

# Security Group

resource "aws_security_group" "this" {
  name = "terraform-ec2-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  tags = {
    Name = var.instance_name
  }
}