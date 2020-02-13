variable "abbreviation" {}
variable "big_query_dataset_ingestion" {}
variable "bu" {}
variable "domain" {}
variable "db_activation_policy" {}
variable "db_availability" {}
variable "db_backup_enable" {}
variable "db_backup_start_time" {}
variable "db_disk_size" {}
variable "db_disk_type" {}
variable "db_instance_type" {}
variable "db_location" {}
variable "db_maintainance_day" {}
variable "db_maintainance_hour" {}
variable "db_maintainance_update_track" {}
variable "db_password" {}
variable "db_username" {}
variable "db_region" {}
variable "db_version" {}
variable "environment" {}
variable "gke_initial_node" {}
variable "gke_max_node_count" {}
variable "gke_node_preemptible" {}
variable "gke_node_machine_type" {}
variable "gke_version" {}
variable "gke_zone" {}
variable "google_credential_file" {}
variable "google_project_id" {}
variable "google_project_region" {}
variable "network_cidr" {}
variable "product" {}
variable "pub_sub_article_clicked" {}
variable "pub_sub_article_read" {}
variable "pub_sub_article_seen" {}
variable "storage_article_upload_bucket_name" {}
variable "storage_article_upload_location" {}
variable "storage_article_upload_storage_class" {}

provider "google" {
  credentials = "${file("${var.google_credential_file}")}"
  project     = "${var.google_project_id}"
  region      = "${var.google_project_region}"
}

module "network" {
  source = "../../modules/network"

  abbreviation = "${var.abbreviation}"
  bu           = "${var.bu}"
  cidr         = "${var.network_cidr}"
  domain       = "${var.domain}"
  environment  = "${var.environment}"
  product      = "${var.product}"
  name         = "${var.abbreviation}-${var.environment}-${var.product}"
}

module "gke" {
  source = "../../modules/gke"

  abbreviation      = "${var.abbreviation}"
  bu                = "${var.bu}"
  cluster_name      = "${var.abbreviation}-${var.environment}-${var.product}"
  cluster_zone      = "${var.gke_zone}"
  environment       = "${var.environment}"
  gke_version       = "${var.gke_version}"
  max_node_count    = "${var.gke_max_node_count}"
  network           = "${module.network.self_link}"
  node_count        = "${var.gke_initial_node}"
  node_machine_type = "${var.gke_node_machine_type}"
  node_preemptible  = "${var.gke_node_preemptible}"
  product           = "${var.product}"
  tags              = "${var.abbreviation}-${var.environment}-${var.product}"
}

/*
  More information about NAT Gateway for GKE Nodes
  https://github.com/GoogleCloudPlatform/terraform-google-nat-gateway/tree/master/examples/gke-nat-gateway
*/

module "nat" {
  source = "github.com/GoogleCloudPlatform/terraform-google-nat-gateway"

  machine_type = "${var.gke_node_machine_type}"
  name         = "${var.abbreviation}-${var.environment}-${var.product}-"
  network      = "${var.abbreviation}-${var.environment}-${var.product}"
  subnetwork   = "${var.abbreviation}-${var.environment}-${var.product}"
  region       = "${var.google_project_region}"
  tags         = ["${var.abbreviation}-${var.environment}-${var.product}"]
  zone         = "${var.gke_zone}"
}

// Route so that traffic to the master goes through the default gateway.
// This fixes things like kubectl exec and logs
resource "google_compute_route" "gke-master-default-gw" {
  name             = "${var.abbreviation}-${var.environment}-${var.product}-gke-master-default-gw"
  dest_range       = "${module.gke.master_ip}"
  network          = "${var.abbreviation}-${var.environment}-${var.product}"
  next_hop_gateway = "default-internet-gateway"

  // next_hop_instance_zone = "${var.gke_zone}"
  tags     = ["${var.abbreviation}-${var.environment}-${var.product}"]
  priority = 700
}

module "pubsub" {
  source = "../../modules/pubsub"

  abbreviation    = "${var.abbreviation}"
  article_clicked = "${var.pub_sub_article_clicked}"
  article_read    = "${var.pub_sub_article_read}"
  article_seen    = "${var.pub_sub_article_seen}"
  environment     = "${var.environment}"
  product         = "${var.product}"
}

module "bigquery" {
  source = "../../modules/bigquery"

  abbreviation = "${var.abbreviation}"
  dataset_name = "${var.big_query_dataset_ingestion}"
  environment  = "${var.environment}"
  product      = "${var.product}"
}

module "cloudstorage" {
  source = "../../modules/cloudstorage"

  abbreviation  = "${var.abbreviation}"
  bucket_name   = "${var.storage_article_upload_bucket_name}"
  environment   = "${var.environment}"
  product       = "${var.product}"
  location      = "${var.storage_article_upload_location}"
  storage_class = "${var.storage_article_upload_storage_class}"
}

module "cloudsql" {
  source = "../../modules/cloudsql"

  abbreviation              = "${var.abbreviation}"
  activation_policy         = "${var.db_activation_policy}"
  availability              = "${var.db_availability}"
  backup_enable             = "${var.db_backup_enable}"
  backup_start_time         = "${var.db_backup_start_time}"
  database_version          = "${var.db_version}"
  disk_size                 = "${var.db_disk_size}"
  disk_type                 = "${var.db_disk_type}"
  environment               = "${var.environment}"
  instance_type             = "${var.db_instance_type}"
  location                  = "${var.db_location}"
  maintainance_day          = "${var.db_maintainance_day}"
  maintainance_hour         = "${var.db_maintainance_hour}"
  maintainance_update_track = "${var.db_maintainance_update_track}"
  password                  = "${var.db_password}"
  product                   = "${var.product}"
  region                    = "${var.db_region}"
  username                  = "${var.db_username}"
}
