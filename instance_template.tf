resource "google_service_account" "default" {
  account_id   = "ldb7-vms"
  display_name = "Service Account"
}

resource "google_compute_instance_template" "default" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["foo", "bar"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false
  scheduling {
    automatic_restart   = true
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
  }

  // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source_image = data.google_compute_image.my_image.self_link
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = <<EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl restart nginx
  EOF

  service_account {
    
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_disk" "foobar" {
  name  = "main-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "europe-west1-c"
}


resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  base_instance_name = "instance-group-manager"
  zone               = "europe-west1-c"
  target_size        = 1

  version {
    instance_template = google_compute_instance_template.default.id
  }
}


resource "google_compute_instance_group_manager" "instance_group_manager2" {
  name               = "instance-group-manager2"
  base_instance_name = "instance-group-manager"
  zone               = "europe-west1-c"
  target_size        = 1

  version {
    instance_template = google_compute_instance_template.default.id
  }
}
