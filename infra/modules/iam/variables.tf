variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "service_account_id" {
  type        = string
  description = "Service Account ID"
}

variable "services" {
  type        = map(any)
  description = "Enabled services map passed from project_services module"
}
