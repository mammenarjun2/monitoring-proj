locals {
  cloud_build_impersonate_roles = [
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",
  ]

 # Add permissons below depending on what is required to be deployed for the project 

  cloud_build_sa_project_roles = [
    "roles/cloudbuild.builds.viewer",
    "roles/cloudbuild.connectionViewer",
    "roles/logging.logWriter",
    "roles/viewer",
    "roles/editor",
    "roles/secretmanager.secretAccessor",
    "roles/logging.admin",
    "roles/storage.admin",

  ]
}

resource "google_service_account" "cloud-build-access" {
  project      = var.project
  account_id   = "cloud-build-access"
  display_name = "Service Account for cloud build, based on project needs"
}

# Allow Cloud Build to issue builds using a user-specified service account

resource "google_service_account_iam_member" "cloud_build_sa_permissions" {
  for_each = toset(local.cloud_build_impersonate_roles)

  service_account_id = google_service_account.cloud-build-access.name
  role               = each.value
  member             = "serviceAccount:${data.google_project.current-project.number}@cloudbuild.gserviceaccount.com"
}

# Cloud Build project service account for deploying infra

resource "google_project_iam_member" "project_access_sa_permissions" {
  for_each = toset(local.cloud_build_sa_project_roles)

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloud-build-access.email}"
}



