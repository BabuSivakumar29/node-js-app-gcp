output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "private_subnet_id" {
  value = google_compute_subnetwork.private.id
}

output "public_subnet_id" {
  value = try(google_compute_subnetwork.public[0].id, null)
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "private_vpc_connection" {
  value = google_service_networking_connection.private_vpc_connection.id
}
