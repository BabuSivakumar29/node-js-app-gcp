# Cloud SQL Instance (MySQL example)
resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance_name
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_self_link
    }
  }
  deletion_protection = false
  depends_on = [
    var.services
  ]
}

# Database inside the instance
resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}

# User for the database
resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.db_instance.name
  password = var.db_password
}
