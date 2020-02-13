variable "abbreviation" {}
variable "bucket_name" {}
variable "cors_max_age" {}
variable "cors_methods" {}
variable "cors_origin" {}
variable "cors_response_header" {}
variable "environment" {}
variable "location" {}
variable "product" {}
variable "storage_class" {}

resource "google_storage_bucket" "upload" {
  name          = "${var.abbreviation}-${var.environment}-${var.product}-${var.bucket_name}"
  location      = "${var.location}"
  storage_class = "${var.storage_class}"

  lifecycle {
    ignore_changes = ["*"]
  }
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = "${google_storage_bucket.upload.name}"
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}
