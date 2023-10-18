resource "google_cloud_scheduler_job" "deletevm_cron_job" {
  name     = "create-vm"
  region = "us-central1"
  schedule = "0 18 * * 1-5"  # This schedule runs the job on mon-fri at 6PM
  time_zone= "Europe/Berlin"

  pubsub_target {
    topic_name = google_pubsub_topic.my_topic.id
    data = base64encode("Deleting VM")  # Encode the data
  }

  retry_config {
    retry_count      = 3
    max_retry_duration = "3600s"
  }
}

resource "google_pubsub_topic" "my_topic" {
  name = "deletevm"
  project = "iac-project-397409"
}
