resource "google_logging_project_sink" "my-sink" {
  name = "metric-sink"

  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project
  destination = "pubsub.googleapis.com/projects/my-project/topics/data-metrics"

  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type = gce_instance AND severity >= WARNING"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}