variable "abbreviation" {}
variable "bu" {}
variable "cidr" {}
variable "domain" {}
variable "environment" {}
variable "name" {}
variable "product" {}

resource "google_compute_network" "default" {
  name                    = "${var.name}"
  auto_create_subnetworks = "true"
}

module "firewall" {
  source = "./firewall"

  abbreviation = "${var.abbreviation}"
  bu           = "${var.bu}"
  environment  = "${var.environment}"
  domain       = "${var.domain}"
  product      = "${var.product}"
  network      = "${google_compute_network.default.name}"
  network_cidr = "${var.cidr}"
}

output "self_link" {
  value = "${google_compute_network.default.self_link}"
}
