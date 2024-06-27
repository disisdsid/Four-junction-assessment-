variable "region" {
  description = "The AWS region to deploy the infrastructure"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group"
  default     = "t2.micro"
}

variable "ami_owner" {
  description = "Owner ID for the Ubuntu AMI"
  default     = "099720109477" # Canonical
}

variable "ami_filter_name" {
  description = "Name filter for the Ubuntu AMI"
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "domain_name" {
  description = "Domain name for Route 53"
  default     = "example.com"
}

variable "subdomain_name" {
  description = "Subdomain name for the A record"
  default     = "nginx"
}
