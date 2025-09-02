variable "vpc_connector_name" {
  type        = string
  description = "Name of the VPC access Connector"
}

variable "region" {
  type        = string
  description = "Region for subnet"
}

variable "vpc_connector_cidr" {
  type        = string
  description = "IP Range for VPC connector"
}

variable "vpc_self_link" {
  type        = string
  description = "The self link of VPC to connector"
}

variable "services" {
  type        = map(any)
  description = "Enabled services map passed from project_services module"
}
