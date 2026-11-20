output "vpc_id" {
  description = "ID of the AegisOps VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = module.vpc.public_subnet_id
}

output "private_subnet_ids" {
  description = "IDs of the private worker subnets."
  value       = module.vpc.private_subnet_ids
}

output "control_plane_instance_id" {
  description = "EC2 instance ID of the Kubernetes control plane."
  value       = module.compute.control_plane_instance_id
}

output "control_plane_public_ip" {
  description = "Public IPv4 address of the control plane. SSH is restricted by admin_cidr."
  value       = module.compute.control_plane_public_ip
}

output "control_plane_private_ip" {
  description = "Private IPv4 address used by Kubernetes nodes."
  value       = module.compute.control_plane_private_ip
}

output "worker_instance_ids" {
  description = "EC2 instance IDs of the Kubernetes workers."
  value       = module.compute.worker_instance_ids
}

output "worker_private_ips" {
  description = "Private IPv4 addresses of the Kubernetes workers."
  value       = module.compute.worker_private_ips
}

output "ssh_command" {
  description = "Example SSH command; replace KEY.pem with your private key path."
  value       = "ssh -i KEY.pem ubuntu@${module.compute.control_plane_public_ip}"
}
