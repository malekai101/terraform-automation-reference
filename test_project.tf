module "test-repo" {
  source  = "app.terraform.io/csmith/developer-repo/github"
  version = "1.0.4"
  # insert required variables here
  project_name = "sample project"
  project_environment = "DEV"
  project_template = "terraform_project_template"
  project_template_owner = "malekai101"

  org_name = "csmith"
  oauth_token_id = var.oauth_token_id
}

module "workspace-config-azure" {
  source  = "app.terraform.io/csmith/workspace-config-azure/tfe"
  version = "1.0.0"
  # insert required variables here
  workspace_name = module.test-repo.tfc_workspace_name
  workspace_organization = "csmith"

  arm_client_id = var.arm_client_id
  arm_subscription_id = var.arm_subscription_id
  arm_tenant_id = var.arm_tenant_id
  arm_client_secret = var.arm_client_secret

  depends_on = [ module.test-repo ]
}

module "workspace-config-aws" {
  source  = "app.terraform.io/csmith/workspace-config-aws/tfe"
  version = "1.0.1"
  # insert required variables here
  workspace_name = module.test-repo.tfc_workspace_name
  workspace_organization = "csmith"

  aws_access_key_id = var.aws_access_key_id
  aws_session_token = var.aws_session_token
  aws_secret_access_key = var.aws_secret_access_key
  
  depends_on = [ module.test-repo ]
}

output test-repo-clone {
    value = module.test-repo.repo_clone_url
}

output test-repo-workspace {
    value = module.test-repo.tfc_workspace_name
}