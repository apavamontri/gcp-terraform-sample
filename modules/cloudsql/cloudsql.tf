variable "abbreviation" {}
variable "activation_policy" {}
variable "availability" {}
variable "backup_enable" {}
variable "backup_start_time" {}
variable "database_version" {}
variable "disk_size" {}
variable "disk_type" {}
variable "environment" {}
variable "instance_type" {}
variable "location" {}
variable "maintainance_day" {}
variable "maintainance_hour" {}
variable "maintainance_update_track" {}
variable "password" {}
variable "product" {}
variable "region" {}
variable "username" {}

resource "google_sql_database_instance" "master" {
  name             = "${var.abbreviation}-${var.environment}-${var.product}-db"
  database_version = "${var.database_version}"
  region           = "${var.region}"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "${var.instance_type}"

    activation_policy = "${var.activation_policy}"
    availability_type = "${var.availability}"

    backup_configuration {
      enabled    = "${var.backup_enable}"
      start_time = "${var.backup_start_time}"
    }

    disk_size = "${var.disk_size}"
    disk_type = "${var.disk_type}"

    location_preference {
      zone = "${var.location}"
    }

    maintenance_window {
      day          = "${var.maintainance_day}"
      hour         = "${var.maintainance_hour}"
      update_track = "${var.maintainance_update_track}"
    }
  }
}

resource "google_sql_user" "users" {
  name     = "${var.username}"
  instance = "${google_sql_database_instance.master.name}"
  password = "${var.password}"
}
