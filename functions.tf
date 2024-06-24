module "cloud_function" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/cloud-function-v2?ref=v32.0.0"
  project_id  = var.project_id
  region      = var.region
  name        = "cf-scc-metric"
  bucket_name = "scc-metric"
  bundle_config = {
    path = "function/"
  }
}
