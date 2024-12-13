resource "google_storage_bucket" "bucket" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.location
  force_destroy               = var.force_destroy
  storage_class               = var.storage_class
  uniform_bucket_level_access = false
  public_access_prevention    = "inherited"

  dynamic "website" {
    for_each = var.website_config == null ? [] : [var.website_config]
    content {
      main_page_suffix = website.value.main_page_suffix
      not_found_page   = website.value.not_found_page
    }
  }

  dynamic "cors" {
    for_each = var.cors_rules
    content {
      origin          = cors.value.origin
      method          = cors.value.method
      response_header = cors.value.response_header
      max_age_seconds = cors.value.max_age_seconds
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      condition {
        age                   = lifecycle_rule.value.condition.age
        with_state            = lifecycle_rule.value.condition.with_state
        created_before        = lifecycle_rule.value.condition.created_before
        matches_storage_class = lifecycle_rule.value.condition.matches_storage_class
      }
      action {
        type = lifecycle_rule.value.action.type
      }
    }
  }

  versioning {
    enabled = var.enable_versioning
  }
}

# Grant public read access
resource "google_storage_bucket_iam_binding" "public_read" {
  bucket  = google_storage_bucket.bucket.name
  role    = "roles/storage.objectViewer"
  members = ["allUsers"]
}

# Grant object creation permissions to any authenticated user
resource "google_storage_bucket_iam_binding" "object_admin" {
  bucket  = google_storage_bucket.bucket.name
  role    = "roles/storage.objectAdmin"
  members = ["allAuthenticatedUsers"]
}

# Legacy ACL for backward compatibility
resource "google_storage_default_object_acl" "default_obj_acl" {
  bucket = google_storage_bucket.bucket.name
  role_entity = [
    "OWNER:project-owners-${var.project_id}",
    "OWNER:project-editors-${var.project_id}",
    "READER:project-viewers-${var.project_id}",
    "READER:allUsers",
  ]
}
