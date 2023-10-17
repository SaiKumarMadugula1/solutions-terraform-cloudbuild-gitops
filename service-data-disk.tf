provider "google" {
  project = "iac-project-397409"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_disk" "data_disk" {
  name  = "my-application-disk"
  type  = "pd-standard"  # Choose the appropriate disk type
  zone  = "us-central1-a"  # Specify the desired zone
  #physical_block_size_bytes = 4096
  size = 5 # GB
}
