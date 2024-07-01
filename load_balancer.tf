resource "google_compute_backened_service" "backend_service" {
  name = "ldb-4"
  protocol = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_check = [google_compute_http_health_check.default.id]
}
resource "google_compute_http_health_check" "ldb_check" {
  name               = "vm_liveness_check"
  request_path       = "/test"
  check_interval_sec = 1
  timeout_sec        = 1
}