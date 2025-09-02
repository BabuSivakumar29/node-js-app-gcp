# Google Chat Notification Channel
resource "google_monitoring_notification_channel" "google_chat" {
  display_name = "Google Chat Alerts"
  type         = "google_chat"

  labels = {
    space = var.google_chat_space
  }
}

# Email Notification Channel
resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Alerts"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

# Log-based Metric
resource "google_logging_metric" "error_count_metric" {
  name        = "cloud_run_error_count"
  description = "Counts error log entries in Cloud Run"
  filter      = "resource.type=\"cloud_run_revision\" severity>=ERROR"

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

# Error Alert Policy (>3 errors in 5 minutes)
resource "google_monitoring_alert_policy" "error_alert" {
  display_name = "Cloud Run Errors > 3"
  combiner     = "OR"

  notification_channels = [
    google_monitoring_notification_channel.google_chat.id,
    google_monitoring_notification_channel.email_channel.id
  ]

  conditions {
    display_name = "More than 3 errors"
    condition_threshold {
      filter = <<EOT
metric.type="logging.googleapis.com/user/${google_logging_metric.error_count_metric.name}"
resource.type="cloud_run_revision"
EOT

      comparison      = "COMPARISON_GT"
      threshold_value = 3
      duration        = "300s" # 5 minutes

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }
}

## CPU Alert Policies

# Warning > 70% (Google Chat)
resource "google_monitoring_alert_policy" "cpu_warning" {
  display_name = "Cloud Run CPU > 70% (Warning)"
  combiner     = "OR"

  notification_channels = [
    google_monitoring_notification_channel.google_chat.id
  ]

  conditions {
    display_name = "CPU > 70%"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/container/cpu/allocation_time\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"${var.cloud_run_service_name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.7 # This is a proxy (not true utilization)
      duration        = "120s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}

# Critical > 80% (Email)
resource "google_monitoring_alert_policy" "cpu_critical" {
  display_name = "Cloud Run CPU > 80% (Critical)"
  combiner     = "OR"

  notification_channels = [
    google_monitoring_notification_channel.email_channel.id
  ]

  conditions {
    display_name = "CPU > 80%"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/container/cpu/allocation_time\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"${var.cloud_run_service_name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      duration        = "120s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}

## Memory Alert Policies

# Warning > 70% (Google Chat)
resource "google_monitoring_alert_policy" "memory_warning" {
  display_name = "Cloud Run Memory > 70% (Warning)"
  combiner     = "OR"

  notification_channels = [
    google_monitoring_notification_channel.google_chat.id
  ]

  conditions {
    display_name = "Memory > 70%"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/container/memory/utilizations\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"${var.cloud_run_service_name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.7   # ratio (0–1)
      duration        = "120s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_PERCENTILE_95"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }
}

# Critical > 80% (Email)
resource "google_monitoring_alert_policy" "memory_critical" {
  display_name = "Cloud Run Memory > 80% (Critical)"
  combiner     = "OR"

  notification_channels = [
    google_monitoring_notification_channel.email_channel.id
  ]

  conditions {
    display_name = "Memory > 80%"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/container/memory/utilizations\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"${var.cloud_run_service_name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      duration        = "120s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_PERCENTILE_95"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }
}
