variable "abbreviation" {}
variable "environment" {}
variable "dataset_name" {}
variable "product" {}

resource "google_bigquery_dataset" "default" {
  dataset_id                  = "${var.abbreviation}_${var.environment}_${var.product}_${var.dataset_name}"
  location                    = "US"
  default_table_expiration_ms = 3600000

  lifecycle {
    ignore_changes = ["*"]
  }
}
