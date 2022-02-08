resource "google_service_account" "deployer_sa" {
    project = var.project_id
    account_id   = "${var.env}-deployer"
    display_name = "Service Account to deploy components from CI/CD server"
}

resource "google_service_account" "cloudrun_pubsub_invoker" {
    project = var.project_id
    account_id   = "${var.env}-cloudrun-pubsub-invoker"
    display_name = "Service Account to invoke the verification cloud run service when a object is uploaded to a bucket"
}

resource "google_project_iam_member" "deployer_binding" {
    project = var.project_id
    role    = "roles/artifactregistry.admin"

    members = [
        "serviceAccount:${google_service_account.deployer_sa.email}",
    ]
}

resource "google_project_iam_member" "deployer_binding_storage" {
    project = var.project_id
    role    = "roles/storage.admin"

    members = [
        "serviceAccount:${google_service_account.deployer_sa.email}",
    ]
}

resource "google_project_iam_member" "deployer_binding_cloudrun" {
    project = var.project_id
    role    = "roles/run.developer"

    members = [
        "serviceAccount:${google_service_account.deployer_sa.email}",
    ]
}

resource "google_project_iam_member" "cloudrun_pubsub_invoker_cloudrun_binding" {
    project = var.project_id
    role    = "roles/run.invoker"

    members = [
        "serviceAccount:${google_service_account.cloudrun_pubsub_invoker.email}",
    ]
}

resource "google_project_iam_member" "pubsub_default_token_binding" {
    project = var.project_id
    role    = "roles/iam.serviceAccountTokenCreator"

    members = [
        "serviceAccount:${local.default_pubsub_sa}",
    ]
}

data "google_compute_default_service_account" "default" {
    project = var.project_id
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_container_registry.registry.id
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

data "google_storage_project_service_account" "gcs_default_account" {
    project = var.project_id
}

resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = google_pubsub_topic.upload_image_topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_default_account.email_address}"]
}