resource "google_service_account" "cloud_run_sa" {
  account_id   = var.service_account_id
  display_name = "Cloud Run Service Account"
}

# Grant required roles to the SA (least privilege)
resource "google_project_iam_member" "cloud_run_roles" {
  for_each = toset([
    "roles/run.admin",                   # Deploy Cloud Run
    "roles/artifactregistry.writer",     # Pull images
    "roles/secretmanager.secretAccessor",# Access secrets
    "roles/cloudsql.client",             # Connect to Cloud SQL
    "roles/serviceusage.viewer0"         # List enabled Services
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  depends_on = [
    var.services
  ]
}
