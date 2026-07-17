provider "aws" {
  region = var.aws_region
}

# Security group - SSH, Jenkins UI, aur website ke ports khole
resource "aws_security_group" "devops_sg" {
  name        = "devops-practice-sg"
  description = "Allow SSH, Jenkins, and web traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Website"
    from_port   = 8081
    to_port     = 8081
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

# EC2 instance - Jenkins + Docker dono yahi install honge
resource "aws_instance" "devops_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    # Docker install
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    # Java install (Jenkins ke liye zaroori hai)
    yum install -y java-17-amazon-corretto

    # Jenkins install
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    yum install -y jenkins
    systemctl start jenkins
    systemctl enable jenkins

    # Jenkins user ko docker use karne do
    usermod -aG docker jenkins
    systemctl restart jenkins
  EOF

  tags = {
    Name = "devops-practice-server"
  }
}