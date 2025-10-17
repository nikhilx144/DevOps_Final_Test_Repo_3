variable "region" {
    description = "AWS Region"
    type = string
}

variable "ami_id" {
    description = "ID of AMI running on the EC2 Instance"
    type = string
}

variable "ec2_instance_type" {
    description = "Type of the EC2 Instance"
    type = string
}

variable "public_key" {
    description = "SSH Public Key"
    type = string
}