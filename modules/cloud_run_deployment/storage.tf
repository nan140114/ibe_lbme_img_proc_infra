# resource "google_storage_bucket_access_control" "public_rule" {
#   bucket = google_storage_bucket.images_public_bucket.name
#   role   = "roles/storage.objectViewer"
#   entity = "allUsers"
# }
resource "google_storage_bucket_iam_binding" "allow_all_user_" {
  bucket = google_storage_bucket.images_public_bucket.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
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