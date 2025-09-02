resource "google_cloud_run_v2_service" "app" {
  name     = var.cloud_run_name
  location = var.region

  deletion_protection = false

  template {
    service_account = var.run_service_account

    containers {
      image = var.app_image

      # DB Password from Secret Manager (v2 way)
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = var.db_secret_name   # secret name in Secret Manager
            version = "latest"
          }
        }
      }

      env {
        name  = "DB_USER"
        value = var.db_user
      }

      env {
        name  = "DB_NAME"
        value = var.db_name
      }

      env {
        name  = "DB_PORT"
        value = var.db_port
      }

      env {
        name  = "DB_HOST"
        value = var.db_private_ip
      }
    }

    vpc_access {
      connector = var.vpc_connector_id
      egress    = "ALL_TRAFFIC"
    }
  }
  depends_on = [
    var.services
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  name  = google_cloud_run_v2_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloud_run_v2_service.app
  ]
}
