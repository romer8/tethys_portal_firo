terraform {
 backend "gcs" {
   bucket  = "firo-410918-terraform-state-bucket"
   prefix  = "terraform/state"
 }
}