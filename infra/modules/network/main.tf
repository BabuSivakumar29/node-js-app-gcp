# Custom VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false

  depends_on = [
    var.services
  ]
}

# Private Subnet (for Cloud SQL, connectors, etc.)
resource "google_compute_subnetwork" "private" {
  name                     = var.private_subnet_name
  ip_cidr_range            = var.private_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true # needed for private services like Cloud SQL
}

# Optional Public Subnet (for bastion, NAT gateway, etc.)
resource "google_compute_subnetwork" "public" {
  count                    = var.create_public_subnet ? 1 : 0
  name                     = var.public_subnet_name
  ip_cidr_range            = var.public_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
}

# Compute Global address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "app-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

# Service networking connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]

  depends_on = [
    google_compute_network.vpc,
    google_compute_global_address.private_ip_alloc
  ]
}
