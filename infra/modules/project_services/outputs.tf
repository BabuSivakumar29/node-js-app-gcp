output "enabled_services" {
  description = "Map of enabled project services"
  value       = google_project_service.enabled
}
