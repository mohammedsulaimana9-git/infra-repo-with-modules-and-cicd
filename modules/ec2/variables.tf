variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "Name of the EC2 instance"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file (e.g. ~/.ssh/id_rsa.pub)"
}

variable "iam_instance_role" {
  type        = string
  description = "Name of the IAM role to attach to the instance"
}