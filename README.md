# Cloud infra terraform task

This project provisions a full AWS environment for a simple web application using a reusable module `app-infra`. It includes VPC networking, EC2 instances, RDS MySQL, monitoring, and Ansible inventory generation.

## Project Structure

```
├── configure-instances.yml        # Ansible playbook for configuring instances
├── main.tf                        # Root Terraform configuration
├── modules
│   └── app-infra                  # Reusable infrastructure module
│       ├── db.tf                  # RDS MySQL resources
│       ├── instances.tf           # EC2 instances & key pair
│       ├── inventory-gen.tf       # Ansible inventory generation
│       ├── inventory.tpl          # Template for inventory
│       ├── networking.tf          # VPC, subnets, IGW, NAT, route tables
│       ├── outputs.tf             # Module outputs
│       └── variables.tf           # Module input variables
├── provider.tf                     # AWS provider configuration
├── terraform.tfvars                # Environment-specific variables
└── variables.tf                    # Root-level variables
```

## Features

* **Networking**

  * VPC with public and private subnets
  * Internet Gateway and NAT Gateway
  * Route tables for public and private subnets

* **Compute**

  * EC2 instances for frontend and backend
  * Key pair generation for SSH
  * Security groups (SSH, HTTP, MySQL)

* **Database**

  * MySQL 8 RDS in private subnets
  * Secure access from EC2 only

* **Monitoring & Alerts**

  * CloudWatch CPU alarms for frontend and backend
  * SNS email notifications

* **Automation**

  * Ansible inventory generated automatically with instance IPs

## Usage

1. Update `terraform.tfvars` with environment-specific values:

   ```hcl
    region               = "us-east-1"
    infra_env            = "dev"
    vpc_cidr             = "10.0.0.0/16"
    public_subnet_cidr   = "10.0.0.0/24"
    private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    az                   = "us-east-1a"
    az_list              = ["us-east-1a", "us-east-1b"]
    instance_type        = "t3.micro"
    rds_instance_class   = "db.t3.micro"
    rds_username         = "adminuser"
    rds_password         = "ChangeMe123!"
    alert_email          = "mi.mostafaibrahim@gmail.com"

   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Preview changes:

   ```bash
   terraform plan
   ```

4. Apply infrastructure:

   ```bash
   terraform apply
   ```

5. SSH into instances using the generated `appinstances-kp.pem` key.

6. Use `configure-instances.yml` with Ansible to configure servers:

   ```bash
   ansible-playbook -i inventory.ini configure-instances.yml
   ```

## Notes
* Remote state is stored in S3 for safety and collaboration.
* RDS is private and not publicly accessible.
* CPU alerts trigger at 50% utilization.
* EC2 root volumes are 8 GB GP2.
* All resources are created via the `app-infra` module for reusability and separation of concerns.
