output "db_password" {
  value = random_password.db_password.result
}

output "db_secret_name" {
  value = google_secret_manager_secret.db_password.name
}
