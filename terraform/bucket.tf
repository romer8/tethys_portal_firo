resource "google_storage_bucket" "statetf" {
  name          = "${var.project_id}-terraform-state-bucket"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  public_access_prevention = "enforced"
}