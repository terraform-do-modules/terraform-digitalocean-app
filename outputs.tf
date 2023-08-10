output "id" {
  value       = digitalocean_app.this[*].id
  description = "ID of the app."
}

output "default_ingress" {
  value       = digitalocean_app.this[*].default_ingress
  description = "The default URL to access the app."
}
##-------------------------------------------------------
## OUTPUT
##-------------------------------------------------------
output "live_url" {
  value       = digitalocean_app.this[*].live_url
  description = "The live URL of the app."
}

output "active_deployment_id" {
  value       = digitalocean_app.this[*].active_deployment_id
  description = "The ID the app's currently active deployment."
}

output "updated_at" {
  value       = digitalocean_app.this[*].updated_at
  description = "The date and time of when the app was last updated."
}

output "created_at" {
  value       = digitalocean_app.this[*].created_at
  description = "The date and time of when the app was created."
}
