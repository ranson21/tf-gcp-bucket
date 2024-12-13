output "bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.bucket
}

output "bucket_name" {
  description = "Bucket name"
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "Bucket URL"
  value       = google_storage_bucket.bucket.url
}

output "public_access_url" {
  description = "Public access URL"
  value       = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}"
}
