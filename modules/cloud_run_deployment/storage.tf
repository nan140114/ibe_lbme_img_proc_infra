resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.images_public_bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "images_public_bucket" {
    project  = var.project_id
    name     = "${var.env}-${var.project_id}-public-images-bucket"
    location = var.location
}

resource "google_storage_bucket" "images_private_bucket" {
    project  = var.project_id
    name     = "${var.env}-${var.project_id}-private-images-bucket"
    location = var.location
}