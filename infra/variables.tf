# Projects and region
variable "project_id" {}
variable "region" {}

# API services
variable "api_services" {
  type = list(string)
}

# Network
variable "vpc_name" {}
variable "private_subnet_name" {}
variable "private_cidr" {}
variable "public_subnet_name" {}
variable "public_cidr" {}
variable "create_public_subnet" {}

# VPC connector
variable "vpc_connector_name" {}
variable "vpc_connector_cidr" {}

# SQL
variable "db_instance_name" {}
variable "db_name" {}
variable "db_user" {}
variable "db_port" {}
#variable "db_password" {}

# Artifact registry
variable "repository_id" {}

# Cloud run
variable "cloud_run_name" {}

# IAM
variable "service_account_id" {}

# Monitoring
variable "alert_email" {}
variable "google_chat_space" {}
variable "memory_limit_bytes" {}
