output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.edge_node.id
}


output "edge_public_ip" {
  description = "Public IP address of Edge instance"
  value       = aws_instance.edge_node.public_ip
}