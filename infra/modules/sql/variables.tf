variable "region" {
  type        = string
  description = "Region for subnet"
}

variable "vpc_self_link" {
  type        = string
  description = "Self link of the VPC"
}

variable "db_instance_name" {
  type        = string
  description = "DB Instance name"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_user" {
  type        = string
  description = "Database User name"
}

variable "db_password" {
  type      = string
  description = "Random password for Database"
}

variable "services" {
  type        = map(any)
  description = "Enabled services map passed from project_services module"
}
