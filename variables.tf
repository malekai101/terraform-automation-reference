
/*
Workspace and GitHub Variables

These variables are stored in TFC and are passed into the 
modules that create the TFC workspace and GitHub repo
and bind them together with webhooks for GitOps
operations.
*/

// The token used by Terraform to authenticate with GitHub.  
variable github_token {}

//The api key used to authenticate back to TFC.  
variable tfe_api_key {}

//The name of the GitHub organization.  
variable github_organization {}
// The oauth token used to configure the GitHub - TFC workspace connection
variable oauth_token_id {}

/*
Azure and AWS Authentication Variables

These variables contain the environmental variables used by
the created workspaces to build in Azure and AWS.  The values
are stored in the the Main workspace varaibles and are passed 
to the cofiguration modules to set the environmental variables
in the created workspaces.
*/

// Azure
variable arm_client_id {}
variable arm_subscription_id {}
variable arm_tenant_id {}
variable arm_client_secret {}

// AWS
variable "aws_access_key_id" {}
variable "aws_session_token" {}
variable "aws_secret_access_key" {}