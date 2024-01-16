provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

resource "helm_release" "firoportal" {
  name       = "firoportal"
  chart      = "../helm/firoportal/"

  values = [
    "${file("../helm/firoportal/values-gke.yaml")}"
  ]
}

resource "google_compute_health_check" "tcp-health-check" {
  name = "firoportal-tcp-health-check"

  timeout_sec        = 15
  check_interval_sec = 15

  tcp_health_check {
    port = "8080"
  }
}

data "external" "update_backend_service_health_checks" {
  program = ["bash", "${path.module}/scripts/update_backend_service_health_checks.sh"]

  query = {
    tcp_health_check_link = google_compute_health_check.tcp-health-check.self_link
    region = var.region
  }

  depends_on = [
    helm_release.firoportal,
    google_compute_health_check.tcp-health-check
  ]
}

output "backend_service" {
  value       = data.external.update_backend_service_health_checks.result.backend_service_name
  description = "GKE Cluster Host"
}

output "external_ip" {
  value       = data.external.update_backend_service_health_checks.result.external_ip
  description = "GKE Cluster Host"
}

