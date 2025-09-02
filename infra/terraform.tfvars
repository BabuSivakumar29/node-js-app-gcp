# Project Details
project_id = "intense-elysium-470611-j0"
region     = "us-east1"

# Services enabled
api_services = [
  "compute.googleapis.com",          # VPC, subnets
  "sqladmin.googleapis.com",         # Cloud SQL
  "secretmanager.googleapis.com",    # Secret Manager
  "run.googleapis.com",              # Cloud Run
  "artifactregistry.googleapis.com", # Artifact Registry
  "vpcaccess.googleapis.com",        # Serverless VPC connector
  "iam.googleapis.com",              # IAM
  "servicenetworking.googleapis.com" # ServiceNetwork
]

# Network
vpc_name             = "app-vpc"
private_subnet_name  = "app-private-subnet"
private_cidr         = "10.0.1.0/24"
create_public_subnet = true
public_subnet_name   = "app-public-subnet"
public_cidr          = "10.0.2.0/24"

# VPC connector
vpc_connector_name = "app-vpc-connector"
vpc_connector_cidr = "10.8.0.0/28"

# SQL
db_instance_name = "app-sql"
db_name          = "appdb"
db_user          = "app_user"
db_port          = "3306"
#db_password = "Changeme!123"

# Artifact registry
repository_id = "app-docker-repo"

# Cloud run
cloud_run_name = "node-js-app"

# IAM
service_account_id = "cloud-run-deployer"

# Monitoring
alert_email = "babumallow02@gmail.com"
google_chat_space = "spaces/AAQAWP8fovs"
memory_limit_bytes = "1073741824"
