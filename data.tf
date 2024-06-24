data "google_project" "current-project" {
  project_id = var.project
}

data "google_secret_manager_secret" "github-token-secret" {
  project   = var.project
  secret_id = "github-token"
}

data "google_secret_manager_secret_version_access" "github-token-secret-version" {
  project = var.project
  secret  = data.google_secret_manager_secret.github-token-secret.id
}

data "google_pubsub_topic" "data-metrics" {
  name = "data-metrics"

}