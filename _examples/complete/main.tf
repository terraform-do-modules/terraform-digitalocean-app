provider "digitalocean" {}

##------------------------------------------------
## app module call
##------------------------------------------------
module "app" {
  source = "./../../"
  spec = [{
    name   = "test"
    region = "nyc"
    domain = {
      name = "test.do.clouddrove.ca"
      type = "PRIMARY"
      zone = "do.clouddrove.ca"
    }

    static_site = {
      name             = "blog"
      build_command    = "bundle exec jekyll build -d ./public"
      environment_slug = "hugo"
      output_dir       = "/public"

      git = {
        repo_clone_url = "https://github.com/digitalocean/sample-jekyll.git"
        branch         = "main"
      }

      routes = {
        path = "/"
      }
    }
  }]
}
