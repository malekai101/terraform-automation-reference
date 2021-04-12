provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

provider "tfe" {
  token = var.tfe_api_key
}


