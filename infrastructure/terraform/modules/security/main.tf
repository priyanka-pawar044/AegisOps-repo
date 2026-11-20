resource "aws_security_group" "control_plane" {
  name        = "${var.project_name}-${var.environment}-control-plane-sg"
  description = "Security group for the AegisOps Kubernetes control plane"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from administrator IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "Kubernetes API from worker nodes"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Kubelet API from cluster nodes"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Calico BGP between cluster nodes"
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Calico VXLAN between cluster nodes"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-control-plane-sg"
  }
}

resource "aws_security_group" "worker" {
  name        = "${var.project_name}-${var.environment}-worker-sg"
  description = "Security group for AegisOps Kubernetes workers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from control plane (admin access via control plane)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.control_plane.id]
  }

  ingress {
    description = "Kubernetes API and kubelet traffic within cluster"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description     = "Kubernetes API from control plane"
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.control_plane.id]
  }

  ingress {
    description     = "Calico BGP between cluster nodes"
    from_port       = 179
    to_port         = 179
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.control_plane.id]
  }

  ingress {
    description = "Calico VXLAN between cluster nodes"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-worker-sg"
  }
}
