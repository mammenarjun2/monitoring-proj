resource "google_compute_backend_service" "backend_service" {
  name = "ldb-4"
  protocol = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks = [google_compute_http_health_check.ldb_check.id]
}
resource "google_compute_http_health_check" "ldb_check" {
  name               = "vm-liveness-check"
  request_path       = "/test"
  check_interval_sec = 1
  timeout_sec        = 1
}