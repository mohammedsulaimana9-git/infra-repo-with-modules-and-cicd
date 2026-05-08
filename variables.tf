variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "key_name" {
  type = string
}
variable "vault_addr" {
  description = "Vault server address"
  type        = string
}

variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true
}

