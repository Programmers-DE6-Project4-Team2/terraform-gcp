resource "google_storage_bucket" "raw_data" {
  name          = "${var.project_id}-raw-data"
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket" "de6_ez2" {
  name          = "de6-ez2"
  location      = var.region
  force_destroy = true
}

# IAM bindings for project members - Storage Admin access
resource "google_project_iam_binding" "storage_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/storage.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Cloud Run Admin access
resource "google_project_iam_binding" "cloud_run_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/run.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Compute Admin access
resource "google_project_iam_binding" "compute_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/compute.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - BigQuery Admin access
resource "google_project_iam_binding" "bigquery_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/bigquery.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - IAM Admin access
resource "google_project_iam_binding" "iam_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Composer User access
resource "google_project_iam_binding" "composer_user" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/composer.user"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Composer Admin access
resource "google_project_iam_binding" "composer_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/composer.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}
