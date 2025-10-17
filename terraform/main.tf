resource "aws_security_group" "ec2_sg" {
    description = "Security Group or Firewall for the EC2 Instance"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "deployer_key" {
    key_name = "deployer_key"
    public_key = var.public_key
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2-ecr-access-profile"
    role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ec2_instance" {
    ami = var.ami_id
    instance_type = var.ec2_instance_type
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

    key_name = aws_key_pair.deployer_key.key_name
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    user_data = <<-EOT
              #!/bin/bash
              # Update all packages
              sudo dnf update -y
              # Install Docker and the AWS CLI
              sudo dnf install -y docker aws-cli
              # Start and enable the Docker service
              sudo systemctl start docker
              sudo systemctl enable docker
              # Add the default user to the docker group
              sudo usermod -a -G docker ec2-user
    EOT

    tags = {
        Name = "WebAppServerDevOpsFinalPrac3"
    }
}

resource "aws_ecr_repository" "app_repo" {
  name = "devops_ci_cd_final_prac_3" # This must match the name in your Jenkinsfile
  image_tag_mutability = "MUTABLE"
  force_delete = true
}