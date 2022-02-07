# resource "google_firestore_document" "images_document" {
#   project     = "my-project-name"
#   collection  = "somenewcollection"
#   document_id = "my-doc-%{random_suffix}"
#   fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"akey\":{\"stringValue\":\"avalue\"}}}}}"
# }

# resource "google_firestore_document" "users_document" {
#   project     = "my-project-name"
#   collection  = "somenewcollection"
#   document_id = "my-doc-%{random_suffix}"
#   fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"akey\":{\"stringValue\":\"avalue\"}}}}}"
# }

# resource "google_firestore_document" "users_document" {
#   project     = "my-project-name"
#   collection  = "somenewcollection"
#   document_id = "my-doc-%{random_suffix}"
#   fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"akey\":{\"stringValue\":\"avalue\"}}}}}"
# }