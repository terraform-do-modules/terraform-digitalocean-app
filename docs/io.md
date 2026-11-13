# Inputs and Outputs: terraform-digitalocean-app

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `enabled` | Flag to control the resources creation. | `bool` | `true` | no |
| `spec` | (Required) A DigitalOcean App spec describing the app. | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `active_deployment_id` | The ID the app's currently active deployment. |
| `created_at` | The date and time of when the app was created. |
| `default_ingress` | The default URL to access the app. |
| `id` | ID of the app. |
| `live_url` | The live URL of the app. |
| `updated_at` | The date and time of when the app was last updated. |
