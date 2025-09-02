# Projects and region
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

# API services
variable "api_services" {
  type = list(string)
}

# Network
variable "vpc_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "private_cidr" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "public_cidr" {
  type = string
}

variable "create_public_subnet" {
  type = string
}

# VPC connector
variable "vpc_connector_name" {
  type = string
}

variable "vpc_connector_cidr" {
  type = string
}

# SQL
variable "db_instance_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_port" {
  type = string
}

# Artifact registry
variable "repository_id" {
  type = string
}

# Cloud run
variable "cloud_run_name" {
  type = string
}

# IAM
variable "service_account_id" {
  type = string
}

# Monitoring
variable "alert_email" {
  type = string
}

variable "google_chat_space" {
  type = string
}

variable "memory_limit_bytes" {
  type = string
}
