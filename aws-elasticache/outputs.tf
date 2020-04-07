output "ec2_instance_public_dns" {
  value = aws_instance.this.public_dns
}

output "redis_primary_endpoint_address" {
  value = aws_elasticache_replication_group.example.primary_endpoint_address
}
