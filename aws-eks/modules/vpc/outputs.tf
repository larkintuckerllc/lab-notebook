output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = [
    aws_subnet.s0.id,
    aws_subnet.s1.id,
    aws_subnet.s2.id,
    aws_subnet.s10.id,
    aws_subnet.s11.id,
    aws_subnet.s12.id
  ]
}

output "public_subnet_ids" {
  value = [
    aws_subnet.s0.id,
    aws_subnet.s1.id,
    aws_subnet.s2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.s10.id,
    aws_subnet.s11.id,
    aws_subnet.s12.id
  ]
}
