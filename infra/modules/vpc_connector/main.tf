# VPC access connector
resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_connector_name
  region        = var.region
  network       = var.vpc_self_link
  ip_cidr_range = var.vpc_connector_cidr

  max_throughput = 300
  min_throughput = 200

  depends_on = [
    var.services
  ]
}
