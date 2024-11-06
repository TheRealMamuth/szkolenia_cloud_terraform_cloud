terraform {
    required_version = ">= 1.6"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
        digitalocean = {
            source  = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
    }
    cloud {
        organization = "first_org_piotrkoska"
        hostname = "app.terraform.io" # Optional; defaults to app.terraform.io

        workspaces {
            name = "szkolenia_cloud_terraform_cloud"
            #project = "Default Project"
        }
    }
}
