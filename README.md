\# AegisOps Terraform Infrastructure



Terraform configuration for the AegisOps development environment on AWS.



\## Architecture



\- Region: `ap-south-1` by default

\- One VPC (`10.20.0.0/16`)

\- One public subnet containing the Kubernetes control-plane EC2 instance

\- Two private subnets containing Kubernetes worker EC2 instances

\- One Internet Gateway

\- One NAT Gateway shared by both private subnets

\- Ubuntu Server 24.04 LTS AMI resolved through AWS Systems Manager Parameter Store

\- Encrypted gp3 root EBS volumes

\- IMDSv2 required

\- SSH to the control plane restricted to `admin\_cidr`



\## Prerequisites



\- Terraform >= 1.6

\- AWS CLI configured with credentials

\- An existing EC2 key pair in `ap-south-1`

\- Your public IP in CIDR notation, ideally `/32`



\## Configure



```bash

cd infrastructure/terraform/environments/dev

cp terraform.tfvars.example terraform.tfvars

```



Edit `terraform.tfvars`:

\- Set `key\_name` to your existing EC2 key pair name.

\- Set `admin\_cidr` to your public IP, e.g. `198.51.100.20/32`.



Do not commit `terraform.tfvars` or private SSH keys.



\## Deploy



```bash

terraform init

terraform fmt -recursive

terraform validate

terraform plan

terraform apply

```



Review the plan carefully before applying. Type `yes` only if the planned resources and costs are understood.



\## Connect



After apply:



```bash

terraform output

```



Use the `ssh\_command` output after replacing `KEY.pem` with the local path to your private key.



Workers have no public IP. Connect to them through the control plane using SSH agent forwarding or ProxyJump, after verifying the relevant SSH key and security-group access.



\## Destroy



When finished with the lab:



```bash

terraform destroy

```



Review the destroy plan before confirming. This deletes the provisioned infrastructure. Back up anything needed first.



\## Important notes



\- A NAT Gateway incurs hourly and data-processing charges even when little traffic is passing through it.

\- EC2, EBS, public IPv4, NAT Gateway, and data transfer may incur AWS charges.

\- The control-plane instance is placed in a public subnet for initial lab access. SSH is restricted to `admin\_cidr`; do not expose SSH to `0.0.0.0/0`.

\- The Kubernetes API port 6443 is not open to the public internet in this configuration.

\- This is a learning/lab topology, not a highly available production design. A production control plane should be private and highly available, with hardened access and an appropriate load balancer.

\- Calico networking ports are included for a common VXLAN/BGP setup. Adjust rules if you choose a different Calico dataplane or CNI.

\- Review current Kubernetes and Calico network requirements before installing the cluster.

\- Terraform state may contain infrastructure metadata. Keep state files private and configure a remote encrypted backend with locking before team use.



