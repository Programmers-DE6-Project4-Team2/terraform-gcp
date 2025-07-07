variable "project_id" {}
variable "region" {
  default = "asia-northeast3"
}
variable "credentials_file" {
  default = "credentials.json"
}

variable "project_members" {
  description = "List of user emails to grant access to GCS, Cloud Run, and VM resources"
  type        = list(string)
  default     = []
}
