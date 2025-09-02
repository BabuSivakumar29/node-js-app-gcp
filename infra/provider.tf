terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "nodejs_tf_backend"
    prefix = "node-js-app/state"
    #    project = var.project_id
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
