variable "project_id" {
  description = "GCP project id"
  type = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "cloud_run_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "run_service_account" {
  description = "Service Account email for Cloud Run"
  type        = string
}

variable "app_image" {
  description = "Container image for Cloud Run"
  type        = string
}

variable "vpc_connector_id" {
  description = "VPC connector ID for Cloud Run"
  type        = string
}


variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = string
}

variable "db_private_ip" {
  description = "DB private IP"
  type        = string
}

variable "db_secret_name" {
  description = "DB password"
  type        = string
}

variable "services" {
  type        = map(any)
  description = "Enabled services map passed from project_services module"
}
