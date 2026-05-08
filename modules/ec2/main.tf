# Generate SSH Key Pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload Public Key to AWS
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}

# Security Group
resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Security group for EC2 instance"

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
  iam_instance_profile   = var.iam_instance_role

  tags = {
    Name = var.instance_name
  }
}

# Store Private Key in Vault
resource "vault_kv_secret_v2" "ec2_pem_key" {
  mount = "secret"
  name  = "aws/ec2/${var.instance_name}-pem"

  data_json = jsonencode({
    private_key = tls_private_key.this.private_key_pem
    public_key  = tls_private_key.this.public_key_openssh
    key_name    = var.key_name
    instance_id = aws_instance.this.id
  })
}