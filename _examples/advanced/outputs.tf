##-------------------------------------------------------
## OUTPUT
##-------------------------------------------------------
output "id" {
  value       = module.app.id
  description = "ID of the app."
}

output "default_ingress" {
  value       = module.app.default_ingress
  description = "The default URL to access the app."
}

output "live_url" {
  value       = module.app.live_url
  description = "The live URL of the app."
}

output "active_deployment_id" {
  value       = module.app.active_deployment_id
  description = "The ID the app's currently active deployment."
}

output "updated_at" {
  value       = module.app.updated_at
  description = "The date and time of when the app was last updated."
}

output "created_at" {
  value       = module.app.created_at
  description = "The date and time of when the app was created."
}
