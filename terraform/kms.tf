resource "google_kms_key_ring" "terraform_state" {
  name     = "terraform-state-bucket"
  location = "us"
}

resource "google_kms_crypto_key" "terraform_state_bucket" {
  name            = "terraform-state-bucket"
  key_ring        = google_kms_key_ring.terraform_state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key_iam_binding" "binding" {
  crypto_key_id = google_kms_crypto_key.terraform_state_bucket.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}