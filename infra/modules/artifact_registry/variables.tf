variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for Artifact registry"
}

variable "repository_id" {
  type        = string
  description = "Repository ID"
}

variable "services" {
  type        = map(any)
  description = "Enabled services map passed from project_services module"
}
