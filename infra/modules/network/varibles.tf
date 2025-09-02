variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "region" {
  type        = string
  description = "Region for subnet"
}

variable "private_subnet_name" {
  type        = string
  description = "Private subnet name"
}

variable "private_cidr" {
  type        = string
  description = "CIDR for private subnet"
}

variable "public_subnet_name" {
  type        = string
  description = "Public subnet name (optional)"
}

variable "public_cidr" {
  type        = string
  description = "CIDR for public subnet (optional)"
}

variable "create_public_subnet" {
  type    = bool
  default = false
}

variable "services" {
  type        = map(any)
  description = "Enabled services map passed from project_services module"
}
