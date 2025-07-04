# Service Account for Serverless Dataproc
resource "google_service_account" "dataproc_service_account" {
  account_id   = "dataproc-serverless-sa"
  display_name = "Dataproc Serverless Service Account"
  description  = "Service account for serverless Dataproc jobs"
}

# IAM bindings for service account
resource "google_project_iam_member" "dataproc_sa_bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_sa_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_sa_dataproc_editor" {
  project = var.project_id
  role    = "roles/dataproc.editor"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}


resource "google_project_iam_member" "dataproc_sa_dataproc_worker" {
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

# Additional IAM permissions for Cloud Run and Airflow integration
resource "google_project_iam_member" "dataproc_sa_cloud_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

# Cloud Run invoker role is defined in cloud_run.tf

resource "google_project_iam_member" "dataproc_sa_artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_sa_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_sa_cloud_build_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_project_iam_member" "dataproc_sa_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

# IAM bindings for team members
resource "google_project_iam_member" "team_bigquery_admin" {
  for_each = toset(var.team_members)
  project  = var.project_id
  role     = "roles/bigquery.admin"
  member   = "user:${each.value}"
}

resource "google_project_iam_member" "team_storage_admin" {
  for_each = toset(var.team_members)
  project  = var.project_id
  role     = "roles/storage.admin"
  member   = "user:${each.value}"
}


resource "google_project_iam_member" "team_dataproc_admin" {
  for_each = toset(var.team_members)
  project  = var.project_id
  role     = "roles/dataproc.admin"
  member   = "user:${each.value}"
}

# Cloud Storage Buckets
resource "google_storage_bucket" "raw_data" {
  name          = "${var.project_id}-raw-data"
  location      = var.region
  force_destroy = true
}

# BigQuery Datasets
resource "google_bigquery_dataset" "beauty_raw_data" {
  dataset_id    = "beauty_raw_data"
  friendly_name = "Beauty Raw Data"
  description   = "Raw data storage for beauty analytics"
  location      = var.region
}

resource "google_bigquery_dataset" "beauty_analytics" {
  dataset_id    = "beauty_analytics"
  friendly_name = "Beauty Analytics"
  description   = "Data warehouse for beauty analytics"
  location      = var.region
}

resource "google_bigquery_dataset" "beauty_adhoc" {
  dataset_id    = "beauty_adhoc"
  friendly_name = "Beauty Ad-hoc"
  description   = "Data mart for visualization and ad-hoc analysis"
  location      = var.region
}

# VM Instance for Airflow Docker Compose
resource "google_compute_instance" "airflow_vm" {
  name         = "airflow-vm"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = google_service_account.dataproc_service_account.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      apt-get update
      apt-get install -y docker.io docker-compose git
      systemctl start docker
      systemctl enable docker
      usermod -aG docker ubuntu
      
      # Install Docker Compose v2
      curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      
      # Create airflow directory and clone repository
      mkdir -p /opt/airflow
      chown ubuntu:ubuntu /opt/airflow
      
      # Clone the Airflow repository as ubuntu user
      sudo -u ubuntu git clone https://github.com/Programmers-DE6-Project4-Team2/airflow.git /opt/airflow
      
      # Start Airflow services
      cd /opt/airflow
      sudo -u ubuntu docker-compose up -d
      
      # Setup SSH key for GitHub deployments
      sudo -u ubuntu mkdir -p /home/ubuntu/.ssh
      chown ubuntu:ubuntu /home/ubuntu/.ssh
      chmod 700 /home/ubuntu/.ssh
    EOT
  }

  tags = ["airflow-vm", "http-server", "https-server"]
}

# Firewall rule for Airflow web UI
resource "google_compute_firewall" "airflow_web" {
  name    = "airflow-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080", "5555"]  # Airflow web UI and Flower
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["airflow-vm"]
}
