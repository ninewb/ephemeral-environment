terraform {
    backend "remote" {
        hostname     = "app.terraform.io"
        organization = "meraxes-actions"
        workspaces { 
            name = "ephemeral-environment" 
        }
    }
}

