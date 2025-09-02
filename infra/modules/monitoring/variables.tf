variable "google_chat_space" {
  description = "Google Chat space ID (format: spaces/XXXX)"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive critical alerts"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name to monitor"
  type        = string
}

variable "memory_limit_bytes" {
  description = "Memory limit of Cloud Run service in bytes"
  type        = number
}
