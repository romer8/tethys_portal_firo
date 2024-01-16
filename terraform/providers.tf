provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  default_labels = {
    aquaveo_project = "firo"
    environment     = var.env
  }
}