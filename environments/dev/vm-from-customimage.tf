# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_firewall" "allow_port_8080" {
  name    = "allow-port-8080"
  network = "projects/iac-project-397409/global/networks/default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["http-server", "https-server"]
}

resource "google_compute_firewall" "allow_port_9090" {
  name    = "allow-port-9090"
  network = "projects/iac-project-397409/global/networks/default"

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["http-server", "https-server"]
}

resource "google_compute_instance" "fedora38-java-mvn-1" {
  boot_disk {
    auto_delete = true
    device_name = "custom-image-template"

    initialize_params {
      image = "projects/iac-project-397409/global/images/fedora38-java-mv-image-1"
      size = 10
      type = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  attached_disk {
    source      = "projects/iac-project-397409/zones/us-central1-a/disks/my-application-disk"  # Reference to the data disk
    device_name = "my-application-disk"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo mkdir /mnt/data
    mount /dev/sdb /mnt/data/
    echo '/dev/sdb /mnt/data ext4 defaults 0 0' >> /etc/fstab
    cd /mnt/data/
    java -jar jenkins.war --httpPort=9090 &
    cd /mnt/data/spring-petclinic
    java -jar target/*.jar &
  EOF

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type     = "e2-medium"
  min_cpu_platform = "Automatic"
  name             = "fedora38-java-mvn-vm"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = "projects/iac-project-397409/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "ansible-ssh@iac-project-397409.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_write","https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server", "lb-health-check"]
  #zone = "us-central1-a"
}
