resource "aws_instance" "control_plane" {
  ami                         = var.ami_id
  instance_type               = var.control_plane_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.control_plane_security_group]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-control-plane"
    Role = "kubernetes-control-plane"
  }
}

resource "aws_instance" "workers" {
  count                       = 2
  ami                         = var.ami_id
  instance_type               = var.worker_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_ids[count.index]
  vpc_security_group_ids      = [var.worker_security_group]
  associate_public_ip_address = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-worker-${count.index + 1}"
    Role = "kubernetes-worker"
  }
}
