variable "abbreviation" {}
variable "bu" {}
variable "cluster_name" {}
variable "cluster_zone" {}
variable "environment" {}
variable "gke_version" {}
variable "max_node_count" {}
variable "network" {}
variable "node_count" {}
variable "node_machine_type" {}
variable "node_preemptible" {}
variable "product" {}
variable "tags" {}

resource "google_container_node_pool" "node_pool" {
  cluster    = "${google_container_cluster.primary.name}"
  name       = "${var.abbreviation}-${var.environment}-${var.product}-pool"
  node_count = "${var.node_count}"

  autoscaling {
    min_node_count = "${var.node_count}"
    max_node_count = "${var.max_node_count}"
  }

  management {
    auto_repair = "true"
  }

  node_config {
    # Minimum scopes to get the cluster working properly
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      abbreviation = "${var.abbreviation}"
      bu           = "${var.bu}"
      environment  = "${var.environment}"
      product      = "${var.product}"
    }

    machine_type = "${var.node_machine_type}"
    preemptible  = "${var.node_preemptible}"
    tags         = ["${var.tags}"]
  }

  version = "${var.gke_version}"
  zone    = "${var.cluster_zone}"
}

resource "google_container_cluster" "primary" {
  min_master_version = "${var.gke_version}"
  name               = "${var.cluster_name}"
  network            = "${var.network}"
  node_version       = "${var.gke_version}"
  zone               = "${var.cluster_zone}"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "19:00" # GMT Time; 2AM local time
    }
  }

  remove_default_node_pool = true
}

output master_ip {
  value = "${google_container_cluster.primary.endpoint}"
}
