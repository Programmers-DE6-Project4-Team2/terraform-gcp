variable "project_id" {}
variable "region" {
  default = "asia-northeast3"
}
variable "credentials_file" {
  default = "credentials.json"
}

# Team members for IAM
variable "team_members" {
  description = "List of team member emails"
  type        = list(string)
  default = [
    "elhanan0905@gmail.com",       # 다윗
    "tjalwled12@gmail.com",      # 미지
    "myksphone2001@gmail.com",   # 미연
    "h2k997183@gmail.com",         # 현호
    "developerminmaco@gmail.com" # 민주
  ]
}

