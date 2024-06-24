
resource "google_cloudbuildv2_connection" "github" {
  provider = google-beta

  project  = var.project
  location = var.region
  name     = "github-connection"

  github_config {
    app_installation_id = var.app_id
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version_access.github-token-secret-version.id
    }
  }
}

resource "google_cloudbuildv2_repository" "github" {
  provider = google-beta

  project           = var.project
  location          = var.region
  name              = "monitoring-proj"
  parent_connection = google_cloudbuildv2_connection.github.name
  remote_uri        = "https://github.com/mammenarjun2/monitoring-proj.git"

  depends_on = [google_cloudbuildv2_connection.github]
}


data "google_iam_policy" "cloudbuild-github-connection" {
  provider = google-beta

  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${data.google_project.current-project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "cloudbuild-github-connection" {
  provider = google-beta

  project     = var.project
  secret_id   = data.google_secret_manager_secret.github-token-secret.secret_id
  policy_data = data.google_iam_policy.cloudbuild-github-connection.policy_data
}

# Create Cloud Build trigger for pull requests
resource "google_cloudbuild_trigger" "pr-branch-trigger" {
  location = var.region
  project  = var.project
  name     = "pull-branch"
  description = "pull requests"

  repository_event_config {
    repository = google_cloudbuildv2_repository.github.id
    pull_request {
      branch = ".*"
    }
  }

  filename       = "scripts/pull/cloudbuild_pull.yaml"
  included_files = ["**"]

  service_account = google_service_account.cloud-build-access.id

  depends_on = [google_cloudbuildv2_repository.github]
}


# Create Cloud Build trigger for main requests 
resource "google_cloudbuild_trigger" "main-branch-trigger" {
  location = var.region
  project  = var.project
  name     = "main-branch"
   description = "merged requests"

  repository_event_config {
    repository = google_cloudbuildv2_repository.github.id
    push {
      branch = "^main$"
    }
  }

  filename       = "scripts/apply/cloudbuild_apply.yaml"
  included_files = ["**"]

  provisioner "local-exec" {
    command = "sleep 5"
  }

  service_account = google_service_account.cloud-build-access.id

  depends_on = [google_cloudbuildv2_repository.github]
}
