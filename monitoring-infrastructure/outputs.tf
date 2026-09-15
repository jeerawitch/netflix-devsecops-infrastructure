output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.netflix_monitoring.id
}

output "elastic_ip" {
  description = "Elastic IP"
  value       = aws_eip.netflix_monitoring.public_ip
}

output "ssh_command" {
  description = "SSH command"
  value       = "ssh -i your-key.pem ubuntu@${aws_eip.netflix_monitoring.public_ip}"
}

output "prometheus_url" {
  value = "http://${aws_eip.netflix_monitoring.public_ip}:9090"
}

output "node_exporter_url" {
  value = "http://${aws_eip.netflix_monitoring.public_ip}:9100"
}

output "grafana_url" {
  value = "http://${aws_eip.netflix_monitoring.public_ip}:3000"
}