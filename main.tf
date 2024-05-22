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
          name         = database.value.name
          engine       = lookup(database.value, "engine", null)
          version      = lookup(database.value, "version", null)
          production   = lookup(database.value, "production", false)
          cluster_name = lookup(database.value, "cluster_name", null)
          db_name      = lookup(database.value, "db_name", null)
          db_user      = lookup(database.value, "db_user", null)
        }
      }

      dynamic "ingress" {
        for_each = length(keys(lookup(spec.value, "ingress", {}))) == 0 ? [] : [lookup(spec.value, "ingress", {})]
        content {
          dynamic "rule" {
            for_each = length(keys(lookup(ingress.value, "rule", {}))) == 0 ? [] : [lookup(ingress.value, "rule", {})]
            content {
              dynamic "component" {
                for_each = length(keys(lookup(ingress.value, "component", {}))) == 0 ? [] : [lookup(ingress.value, "component", {})]
                content {
                  name                 = component.value.name
                  preserve_path_prefix = component.value.preserve_path_prefix
                  rewrite              = component.value.rewrite
                }
              }
              dynamic "match" {
                for_each = length(keys(lookup(ingress.value, "match", {}))) == 0 ? [] : [lookup(ingress.value, "match", {})]
                content {
                  dynamic "path" {
                    for_each = length(keys(lookup(ingress.value, "path", {}))) == 0 ? [] : [lookup(ingress.value, "path", {})]
                    content {
                      prefix = path.value.prefix
                    }
                  }
                }
              }
              dynamic "redirect" {
                for_each = length(keys(lookup(ingress.value, "redirect", {}))) == 0 ? [] : [lookup(ingress.value, "redirect", {})]
                content {
                  uri           = redirect.value.uri
                  authority     = redirect.value.authority
                  port          = redirect.value.port
                  scheme        = redirect.value.scheme
                  redirect_code = redirect.value.redirect_code
                }
              }
              dynamic "cors" {
                for_each = length(keys(lookup(ingress.value, "cors", {}))) == 0 ? [] : [lookup(ingress.value, "cors", {})]
                content {
                  max_age           = cors.value.max_age
                  allow_credentials = cors.value.allow_credentials
                  allow_headers     = cors.value.allow_headers
                  expose_headers    = cors.value.expose_headers
                  dynamic "allow_origins" {
                    for_each = length(keys(lookup(ingress.value, "allow_origins", {}))) == 0 ? [] : [lookup(ingress.value, "allow_origins", {})]
                    content {
                      exact  = allow_origins.value.exact
                      prefix = allow_origins.value.prefix
                      regex  = allow_origins.value.regex
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "function" {
        for_each = length(keys(lookup(spec.value, "function", {}))) == 0 ? [] : [lookup(spec.value, "function", {})]
        content {
          name       = function.value.name
          source_dir = lookup(function.value, "source_dir", null)
          dynamic "git" {
            for_each = length(keys(lookup(function.value, "git", {}))) == 0 ? [] : [lookup(function.value, "git", {})]
            content {
              repo_clone_url = git.value.repo_clone_url
              branch         = lookup(git.value, "branch", "master")
            }
          }
          dynamic "github" {
            for_each = length(keys(lookup(function.value, "github", {}))) == 0 ? [] : [lookup(function.value, "github", {})]
            content {
              repo           = github.value.repo
              branch         = lookup(github.value, "branch", "master")
              deploy_on_push = lookup(github.value, "deploy_on_push", true)
            }
          }
          dynamic "gitlab" {
            for_each = length(keys(lookup(function.value, "gitlab", {}))) == 0 ? [] : [lookup(function.value, "gitlab", {})]
            content {
              repo           = gitlab.value.repo
              branch         = lookup(gitlab.value, "branch", "master")
              deploy_on_push = lookup(gitlab.value, "deploy_on_push", true)
            }
          }

          dynamic "env" {
            for_each = lookup(function.value, "env", [])
            content {
              key   = env.value.key
              value = env.value.value
              scope = lookup(env.value, "scope", "RUN_AND_BUILD_TIME")
              type  = env.value.type
            }
          }

          dynamic "alert" {
            for_each = length(keys(lookup(function.value, "alert", {}))) == 0 ? [] : [lookup(function.value, "alert", {})]
            content {
              rule     = lookup(alert.value, "rule", null)
              value    = lookup(alert.value, "value", null)
              operator = lookup(alert.value, "operator", null)
              window   = lookup(alert.value, "window", null)
              disabled = lookup(alert.value, "disabled", false)
            }
          }

          dynamic "log_destination" {
            for_each = length(keys(lookup(function.value, "log_destination", {}))) == 0 ? [] : [lookup(function.value, "log_destination", {})]
            content {
              name = log_destination.value.name
              dynamic "papertrail" {
                for_each = length(keys(lookup(log_destination.value, "papertrail", {}))) == 0 ? [] : [lookup(log_destination.value, "papertrail", {})]
                content {
                  endpoint = lookup(log_destination.value, "endpoint", null)
                }
              }
              dynamic "datadog" {
                for_each = length(keys(lookup(log_destination.value, "datadog", {}))) == 0 ? [] : [lookup(log_destination.value, "datadog", {})]
                content {
                  api_key = lookup(log_destination.value, "api_key", null)
                }
              }
              dynamic "logtail" {
                for_each = length(keys(lookup(log_destination.value, "logtail", {}))) == 0 ? [] : [lookup(log_destination.value, "logtail", {})]
                content {
                  token = lookup(log_destination.value, "token", null)
                }
              }
            }
          }
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
        }
      }

      dynamic "service" {
        for_each = length(keys(lookup(spec.value, "service", {}))) == 0 ? [] : [lookup(spec.value, "service", {})]
        content {
          name               = lookup(service.value, "name", spec.value.name)
          build_command      = lookup(service.value, "build_command", null)
          dockerfile_path    = lookup(service.value, "dockerfile_path", null)
          source_dir         = lookup(service.value, "source_dir", null)
          run_command        = lookup(service.value, "run_command", null)
          environment_slug   = lookup(service.value, "environment_slug", null)
          instance_size_slug = lookup(service.value, "instance_size_slug", "basic-xxs")
          instance_count     = lookup(service.value, "instance_count", 1)
          http_port          = lookup(service.value, "http_port", 80)
          internal_ports     = lookup(service.value, "internal_ports", null)

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
              port                  = lookup(health_check.value, "port", null)
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
