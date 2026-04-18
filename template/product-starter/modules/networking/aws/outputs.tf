output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID."
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs."
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet IDs."
}

output "cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "VPC CIDR (for security group rules)."
}

output "network_arn" {
  value       = "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vpc/${aws_vpc.this.id}"
  description = "Globally unique resource identifier for the network (ARN for AWS, ARM ID for Azure, self_link for GCP). Under LocalStack, account_id is 000000000000."
}
