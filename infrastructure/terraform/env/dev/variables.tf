variable "aws_region" {
  description = "AWS region in which to deploy AegisOps."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used in resource names and tags."
  type        = string
  default     = "aegisops"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR range for the AegisOps VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR range for private subnet 1."
  type        = string
  default     = "10.20.11.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR range for private subnet 2."
  type        = string
  default     = "10.20.12.0/24"
}

variable "availability_zones" {
  description = "Two availability zones in the selected AWS region."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Provide exactly two availability zones."
  }
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in the selected region."
  type        = string
}

variable "admin_cidr" {
  description = "Your public IP in CIDR notation, for example 203.0.113.10/32. Restricts SSH to the control plane."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid CIDR range, preferably your public IP with /32."
  }
}

variable "control_plane_instance_type" {
  description = "EC2 instance type for the Kubernetes control plane."
  type        = string
  default     = "t3.large"
}

variable "worker_instance_type" {
  description = "EC2 instance type for Kubernetes workers."
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB for each node."
  type        = number
  default     = 30
}

variable "ssh_username" {
  description = "SSH username for Ubuntu AMIs."
  type        = string
  default     = "ubuntu"
}
