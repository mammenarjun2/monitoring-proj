/*
resource "google_storage_bucket" "tf-state" {
  name          = "tf-state-${var.project}"
  project       = var.project 
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}
*/