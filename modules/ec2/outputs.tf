output "id" {
  description = "The ID of the instance"
  value       = try(aws_instance.this[0].id, null)
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = try(aws_instance.this[0].private_ip, null)
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = try(aws_instance.this[0].public_ip, null)
}

output "credit_specification" {
  description = "Credit specification of the instance (for T instance types)"
  value       = try(aws_instance.this[0].credit_specification, null)
}