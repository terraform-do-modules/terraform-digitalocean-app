##-------------------------------------------
## Provides a DigitalOcean App resource.
##------------------------------------------
resource "digitalocean_app" "this" {
  count = var.enabled ? 1 : 0
  dynamic "spec" {
    for_each = try(jsondecode(var.spec), var.spec)
    content {
      name   = spec.value.name
      region = spec.value.region
      dynamic "domain" {
        for_each = length(keys(lookup(spec.value, "domain", {}))) == 0 ? [] : [lookup(spec.value, "domain", {})]
        content {
          name     = domain.value.name
          type     = lookup(domain.value, "type", null)
          wildcard = lookup(domain.value, "wildcard", null)
          zone     = lookup(domain.value, "zone", null)
        }
      }

      dynamic "env" {
        for_each = lookup(spec.value, "env", [])
        content {
          key   = env.value.key
          value = env.value.value
          scope = lookup(env.value, "scope", "RUN_AND_BUILD_TIME")
          type  = env.value.type
        }
      }
      dynamic "database" {
        for_each = length(keys(lookup(spec.value, "database", {}))) == 0 ? [] : [lookup(spec.value, "database", {})]
        content {
           name     = database.value.name
           engine = database.value.engine
           version = database.value.version
           production = database.value.production
           cluster_name = database.value.cluster_name
           db_name = database.value.db_name
           db_user = database.value.db_user
        }
        
      }

      dynamic "static_site" {
        for_each = length(keys(lookup(spec.value, "static_site", {}))) == 0 ? [] : [lookup(spec.value, "static_site", {})]
        content {
          name              = static_site.value.name
          build_command     = lookup(static_site.value, "build_command", null)
          dockerfile_path   = lookup(static_site.value, "dockerfile_path", null)
          source_dir        = lookup(static_site.value, "source_dir", null)
          environment_slug  = static_site.value.environment_slug
          output_dir        = lookup(static_site.value, "output_dir", null)
          index_document    = lookup(static_site.value, "index_document", null)
          error_document    = lookup(static_site.value, "error_document", null)
          catchall_document = lookup(static_site.value, "catchall_document", null)

          dynamic "git" {
            for_each = length(keys(lookup(static_site.value, "git", {}))) == 0 ? [] : [lookup(static_site.value, "git", {})]
            content {
              repo_clone_url = git.value.repo_clone_url
              branch         = lookup(git.value, "branch", "master")
            }
          }

          dynamic "github" {
            for_each = length(keys(lookup(static_site.value, "github", {}))) == 0 ? [] : [lookup(static_site.value, "github", {})]
            content {
              repo           = github.value.repo
              branch         = lookup(github.value, "branch", "master")
              deploy_on_push = lookup(github.value, "deploy_on_push", true)
            }
          }

          dynamic "gitlab" {
            for_each = length(keys(lookup(static_site.value, "gitlab", {}))) == 0 ? [] : [lookup(static_site.value, "gitlab", {})]
            content {
              repo           = gitlab.value.repo
              branch         = lookup(gitlab.value, "branch", "master")
              deploy_on_push = lookup(gitlab.value, "deploy_on_push", true)
            }
          }

          dynamic "env" {
            for_each = lookup(static_site.value, "env", [])
            content {
              key   = env.value.key
              value = env.value.value
              scope = lookup(env.value, "scope", "RUN_AND_BUILD_TIME")
              type  = env.value.type
            }
          }

          dynamic "routes" {
            for_each = length(keys(lookup(static_site.value, "routes", {}))) == 0 ? [] : [lookup(static_site.value, "routes", {})]
            content {
              path = lookup(routes.value, "path", "/")
            }
          }

          dynamic "cors" {
            for_each = lookup(static_site.value, "cors", [])
            content {
              allow_headers     = lookup(cors.value, "allow_headers", null)
              max_age           = lookup(cors.value, "max_age", null)
              expose_headers    = lookup(cors.value, "expose_headers", null)
              allow_methods     = lookup(cors.value, "allow_methods", null)
              allow_credentials = lookup(cors.value, "allow_credentials", null)
            }
          }

          dynamic "env" {
            for_each = lookup(static_site.value, "env", [])
            content {
              key   = env.value.key
              value = env.value.value
              scope = lookup(env.value, "scope", "RUN_AND_BUILD_TIME")
              type  = env.value.type
            }
          }
        }
      }


      dynamic "service" {
        for_each = length(keys(lookup(spec.value, "service", {}))) == 0 ? [] : [lookup(spec.value, "service", {})]
        content {
          name               = spec.value.name
          build_command      = lookup(spec.value, "build_command", null)
          dockerfile_path    = lookup(spec.value, "dockerfile_path", null)
          source_dir         = lookup(spec.value, "source_dir", null)
          run_command        = lookup(spec.value, "run_command", null)
          environment_slug   = lookup(spec.value, "environment_slug", null)
          instance_size_slug = lookup(spec.value, "instance_size_slug", "basic-xxs")
          instance_count     = lookup(spec.value, "instance_count", 1)
          http_port          = lookup(spec.value, "http_port", 80)
          internal_ports     = lookup(spec.value, "internal_ports", null)

          dynamic "image" {
            for_each = length(keys(lookup(service.value, "image", {}))) == 0 ? [] : [lookup(service.value, "image", {})]
            content {
              registry_type = lookup(image.value, "registry_type", null)
              registry      = lookup(image.value, "registry", null)
              repository    = lookup(image.value, "repository", null)
              tag           = lookup(image.value, "tag", "latest")
              dynamic "deploy_on_push" {
                for_each = length(keys(lookup(image.value, "deploy_on_push", {}))) == 0 ? [] : [lookup(image.value, "deploy_on_push", {})]
                content {
                  enabled = lookup(deploy_on_push.value, "enabled", true)
                }
              }
            }
          }

          dynamic "git" {
            for_each = length(keys(lookup(service.value, "git", {}))) == 0 ? [] : [lookup(service.value, "git", {})]
            content {
              repo_clone_url = git.value.repo_clone_url
              branch         = lookup(git.value, "branch", "master")
            }
          }

          dynamic "github" {
            for_each = length(keys(lookup(service.value, "github", {}))) == 0 ? [] : [lookup(service.value, "github", {})]
            content {
              repo           = github.value.repo
              branch         = lookup(github.value, "branch", "master")
              deploy_on_push = lookup(github.value, "deploy_on_push", true)
            }
          }

          dynamic "gitlab" {
            for_each = length(keys(lookup(service.value, "gitlab", {}))) == 0 ? [] : [lookup(service.value, "gitlab", {})]
            content {
              repo           = gitlab.value.repo
              branch         = lookup(gitlab.value, "branch", "master")
              deploy_on_push = lookup(gitlab.value, "deploy_on_push", true)
            }
          }

          dynamic "env" {
            for_each = lookup(service.value, "env", [])
            content {
              key   = env.value.key
              value = env.value.value
              scope = lookup(env.value, "scope", "RUN_AND_BUILD_TIME")
              type  = env.value.type
            }
          }

          dynamic "routes" {
            for_each = length(keys(lookup(service.value, "routes", {}))) == 0 ? [] : [lookup(service.value, "routes", {})]
            content {
              path = lookup(routes.value, "path", "/")
            }
          }

          dynamic "cors" {
            for_each = lookup(service.value, "cors", [])
            content {
              allow_headers     = lookup(cors.value, "allow_headers", null)
              max_age           = lookup(cors.value, "max_age", null)
              expose_headers    = lookup(cors.value, "expose_headers", null)
              allow_methods     = lookup(cors.value, "allow_methods", null)
              allow_credentials = lookup(cors.value, "allow_credentials", null)
            }
          }
          dynamic "alert" {
            for_each = length(keys(lookup(service.value, "alert", {}))) == 0 ? [] : [lookup(service.value, "alert", {})]
            content {
              rule     = lookup(alert.value, "rule", null)
              value    = lookup(alert.value, "value", null)
              operator = lookup(alert.value, "operator", null)
              window   = lookup(alert.value, "window", null)
              disabled = lookup(alert.value, "disabled", false)
            }
          }
          dynamic "health_check" {
            for_each = length(keys(lookup(service.value, "health_check", {}))) == 0 ? [] : [lookup(service.value, "health_check", {})]
            content {
              http_path             = lookup(health_check.value, "http_path", null)
              initial_delay_seconds = lookup(health_check.value, "initial_delay_seconds", null)
              period_seconds        = lookup(health_check.value, "period_seconds", null)
              timeout_seconds       = lookup(health_check.value, "timeout_seconds", null)
              success_threshold     = lookup(health_check.value, "success_threshold", null)
              failure_threshold     = lookup(health_check.value, "failure_threshold", null)
            }
          }
        }
      }
    }
  }
}
