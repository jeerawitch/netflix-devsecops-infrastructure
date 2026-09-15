output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.netflix_jenkins.id
}

output "elastic_ip" {
  description = "Elastic IP"
  value       = aws_eip.netflix_jenkins.public_ip
}

output "ssh_command" {
  description = "SSH command"
  value       = "ssh -i your-key.pem ubuntu@${aws_eip.netflix_jenkins.public_ip}"
}

output "jenkins_url" {
  value = "http://${aws_eip.netflix_jenkins.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_eip.netflix_jenkins.public_ip}:9000"
}

output "app_url" {
  value = "http://${aws_eip.netflix_jenkins.public_ip}:8081"
}