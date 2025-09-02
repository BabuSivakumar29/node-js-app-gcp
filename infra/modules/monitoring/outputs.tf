output "error_alert_policy_id" {
  value = google_monitoring_alert_policy.error_alert.id
}

output "cpu_warning_alert_policy_id" {
  value = google_monitoring_alert_policy.cpu_warning.id
}

output "cpu_critical_alert_policy_id" {
  value = google_monitoring_alert_policy.cpu_critical.id
}

output "memory_warning_alert_policy_id" {
  value = google_monitoring_alert_policy.memory_warning.id
}

output "memory_critical_alert_policy_id" {
  value = google_monitoring_alert_policy.memory_critical.id
}
