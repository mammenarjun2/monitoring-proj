
data "google_compute_instance_group" "instance_group_manager" {
    name = "instance-group-manager"
    zone = "europe-west1-c"
}

data "google_compute_instance_group" "instance_group_manager2" {
    name = "instance-group-manager2"
    zone = "europe-west1-c"
}

resource "google_compute_backend_service" "backend_service" {
  name                 = "ldb-4"
  protocol             = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks        = [google_compute_http_health_check.ldb_check.id]
  
  backend {
    group             = data.google_compute_instance_group.instance_group_manager.id
    balancing_mode    = "UTILIZATION"
    capacity_scaler   = 0.5
    max_utilization   = 0.5
  }

  backend {
    group             = data.google_compute_instance_group.instance_group_manager2.id
    balancing_mode    = "UTILIZATION"
    capacity_scaler   = 0.5
    max_utilization   = 0.5
  }
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
