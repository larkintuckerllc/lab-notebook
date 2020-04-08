output "ec2_instance_public_dns" {
  value = aws_instance.this.public_dns
}

output "db_instance_endpoint" {
  value = aws_db_instance.this.endpoint
}
