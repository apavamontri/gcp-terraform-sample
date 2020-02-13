variable "abbreviation" {}
variable "bu" {}
variable "environment" {}
variable "domain" {}
variable "product" {}
variable "network" {}
variable "network_cidr" {}

# allow-internal 65534
resource "google_compute_firewall" "allow-internal" {
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  name          = "${var.abbreviation}-${var.environment}-allow-internal"
  network       = "${var.network}"
  priority      = "65534"
  source_ranges = ["${var.network_cidr}"]
}

# allow-ssh 22 65534
resource "google_compute_firewall" "allow-ssh" {
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  name          = "${var.abbreviation}-${var.environment}-allow-ssh"
  network       = "${var.network}"
  priority      = "65534"
  source_ranges = ["0.0.0.0/0"]
}

# allow-icmp 65534

