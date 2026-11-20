data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source = "../../modules/vpc"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zones    = local.selected_azs
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  admin_cidr   = var.admin_cidr
}

module "compute" {
  source = "../../modules/compute"

  project_name                 = var.project_name
  environment                  = var.environment
  ami_id                       = data.aws_ssm_parameter.ubuntu_ami.value
  key_name                     = var.key_name
  control_plane_instance_type  = var.control_plane_instance_type
  worker_instance_type         = var.worker_instance_type
  root_volume_size             = var.root_volume_size
  ssh_username                 = var.ssh_username
  public_subnet_id             = module.vpc.public_subnet_id
  private_subnet_ids           = module.vpc.private_subnet_ids
  control_plane_security_group = module.security.control_plane_security_group_id
  worker_security_group        = module.security.worker_security_group_id
}
