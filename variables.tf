variable "aws_region" {
  default = "us-east-1"   # Mumbai region, tumhare paas nearest hai
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
  default     = "ami-01edba92f9036f76e"  # ap-south-1 ke liye Amazon Linux 2023
}

variable "instance_type" {
  default = "t2.micro"   # free tier eligible
}