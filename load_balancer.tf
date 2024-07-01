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

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name        = "http-forwarding-rule"
  target      = google_compute_target_http_proxy.http_proxy.self_link
  port_range  = "80"
  ip_protocol = "TCP"
}

resource "google_compute_address" "global_address" {
  name = "global-address"
  region = "europe-west1"
}