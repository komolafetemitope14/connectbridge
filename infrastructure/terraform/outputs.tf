
output "project_name" {
  description = "ConnectBridge project name"
  value       = var.project_name
}

output "environment" {
  description = "Current deployment environment"
  value       = var.environment
}

output "network_name" {
  description = "ConnectBridge Docker network name"
  value       = docker_network.connectbridge.name
}

output "network_id" {
  description = "ConnectBridge Docker network ID"
  value       = docker_network.connectbridge.id
}

output "volume_name" {
  description = "ConnectBridge persistent volume name"
  value       = docker_volume.connectbridge_data.name
}

output "volume_mountpoint" {
  description = "Docker-managed volume mount point"
  value       = docker_volume.connectbridge_data.mountpoint
}
