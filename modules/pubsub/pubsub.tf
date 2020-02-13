variable "abbreviation" {}
variable "article_clicked" {}
variable "article_read" {}
variable "article_seen" {}
variable "environment" {}
variable "product" {}

resource "google_pubsub_topic" "article_clicked_topic" {
  name = "${var.abbreviation}-${var.environment}-${var.product}-${var.article_clicked}"
}

resource "google_pubsub_topic" "article_read_topic" {
  name = "${var.abbreviation}-${var.environment}-${var.product}-${var.article_read}"
}

resource "google_pubsub_topic" "article_seen_topic" {
  name = "${var.abbreviation}-${var.environment}-${var.product}-${var.article_seen}"
}
