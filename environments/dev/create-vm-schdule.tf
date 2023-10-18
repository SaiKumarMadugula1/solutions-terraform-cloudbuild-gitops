resource "google_cloud_scheduler_job" "createvm_cron_job" {
  name     = "create-vm"
  region = "us-central1"
  schedule = "0 7 * * 1-5"  # This schedule runs the job on mon-fri at 7AM
  time_zone= "Europe/Berlin"

  pubsub_target {
    topic_name = google_pubsub_topic.createvm_topic.id
    data = base64encode("Creating VM")  # Encode the data
  }

  retry_config {
    retry_count      = 3
    max_retry_duration = "3600s"
  }
}

# resource "google_pubsub_topic" "createvm_topic" {
#   name = "createvm"
#   project = "iac-project-397409"
# }
