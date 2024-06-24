resource "google_logging_project_sink" "my-sink" {
  name = "metric-sink"

  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project
  destination = data.google_pubsuv_topic.data-metrics

  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type = gce_instance AND severity >= WARNING"

}