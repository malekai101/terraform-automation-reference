resource "tfe_policy_set" "azure_web_set" {
  name          = "azure-auto-policies"
  description   = "A policy set for Azure web resources"
  organization  = "csmith"
  policies_path = "/azure"
  workspace_ids = [
    module.test-repo.tfc_workspace_id
  ]

  vcs_repo {
    identifier         = "malekai101/sentinel_tfc"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = var.oauth_token_id
  }
}

resource "tfe_policy_set" "aws_web_set" {
  name          = "aws-auto-policies"
  description   = "A policy set for AWS web resources"
  organization  = "csmith"
  policies_path = "/aws"
  workspace_ids = [
    module.test-repo.tfc_workspace_id
  ]

  vcs_repo {
    identifier         = "malekai101/sentinel_tfc"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = var.oauth_token_id
  }
}
