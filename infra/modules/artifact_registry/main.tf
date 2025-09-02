#resource "google_artifact_registry_repository" "docker_repo" {
#  project       = var.project_id
#  location      = var.region
#  repository_id = var.repository_id
#  description   = "Docker repository for my app"
#  format        = "DOCKER"
#
#  depends_on = [
#    var.services
#  ]
#}

resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for my app"
  format        = "DOCKER"

  depends_on = [
    var.services
  ]
}

# Docker build & push after the repository is ready
resource "null_resource" "docker_build_push" {
  depends_on = [
    google_artifact_registry_repository.docker_repo
  ]

  triggers = {
    project = var.project_id
    region  = var.region
    repo    = var.repository_id
  }

  provisioner "local-exec" {
    command = <<EOT
#!/bin/bash
set -e

PROJECT_ID=${var.project_id}
REGION=${var.region}
REPO=${var.repository_id}
IMAGE="node-app"


cd ../

echo "Building Docker image..."
docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$IMAGE:latest .

echo "Configuring Docker for GCP..."
gcloud auth configure-docker $REGION-docker.pkg.dev

echo "Pushing Docker image..."
docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$IMAGE:latest
EOT
  }
}
