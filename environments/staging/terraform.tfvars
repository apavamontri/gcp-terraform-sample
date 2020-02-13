abbreviation = "zrs"

bu = "zrs"

domain = "zeroslide.io"

environment = "stg"

product = "zrs"

# GKE

gke_initial_node = 3

gke_max_node_count = 12

gke_node_preemptible = false

gke_node_machine_type = "n1-standard-1"

gke_version = "1.10.2-gke.1"

gke_zone = "asia-east1-c" # master and nodes will be created here

google_credential_file = "../../xxx.json"

google_project_id = "xxx-123"

google_project_region = "asia-east1"

# Works with network with "auto" type
network_cidr = "10.128.0.0/9"

zones = "asia-east1-a,asia-east1-b,asia-east1-c"

# Pub Sub
pub_sub_article_clicked = "article-clicked"

pub_sub_article_read = "article-read"

pub_sub_article_seen = "article-seen"

# BigQuery
big_query_dataset_ingestion = "ingestion"

# Cloud Storage
storage_article_upload_bucket_name = "article-upload"

storage_article_upload_location = "ASIA-EAST1"

storage_article_upload_storage_class = "REGIONAL" # Cloud SQL

db_activation_policy = "ALWAYS" // ALWAYS, NEVER or ON_DEMAND

db_availability = "ZONAL" // high availability  (REGIONAL) or single zone (ZONAL).

db_backup_enable = "true"

db_backup_start_time = "18:00" // UTC

db_disk_size = "100" // GB

db_disk_type = "PD_SSD"

db_instance_type = "db-custom-2-7680" // 2 vCPU and 7.5GB (must convert to Memory to MB)

db_location = "asia-east1-c"

db_maintainance_day = "2" // TUESDAY

db_maintainance_hour = "21" // 24 hours in UTC

db_maintainance_update_track = "stable" // earlier (canary) or later (stable)

db_username = "zrs_user"

db_password = "change_me!"

db_region = "asia-east1"

db_version = "POSTGRES_9_6"
