data "google_project" "project" {
    project_id = var.project_id
}

locals {
  default_pubsub_sa = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  default_apigw_sa  = "service-${data.google_project.project.number}@gcp-sa-apigateway.iam.gserviceaccount.com"
}