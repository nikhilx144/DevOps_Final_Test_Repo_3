output "ec2_public_ip" {
    description = "Public IP of the EC2 Instance"
    value = aws_instance.ec2_instance.public_ip
}