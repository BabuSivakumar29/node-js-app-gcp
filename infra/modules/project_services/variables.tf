variable "project_id" {
  description = "The GCP project ID where APIs should be enabled"
  type        = string
}

variable "api_services" {
  description = "List of GCP APIs to enable"
  type        = list(string)
}
