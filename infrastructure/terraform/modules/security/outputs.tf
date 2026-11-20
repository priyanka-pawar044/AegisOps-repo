output "control_plane_security_group_id" {
  value = aws_security_group.control_plane.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker.id
}
