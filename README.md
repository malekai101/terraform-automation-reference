# Terraform Workspace Automation Example

## Introduction  

This repository is a sample project demonstrating an automated approach to management of a Terraform Enterprise or Terraform Cloud organization.  This README will describe the various parts of the project and the workflow.  Modules are referenced in the project.  The code for these modules is public.  

The project is a valid management pattern for both Terraform Enterprise and Terraform Cloud.  These products have feature parity and the code examples in this project will work for either product.  Though the code would work in either environment, the term Terraform Cloud will be used here for simplicity.  The project will be tied to a dedicated Terraform Cloud workspace which will be referred to throughout as the Main workspace.

The code example provided demonstrates the creation and configuration of Terraform Cloud workspaces and GitHub projects.  The Terraform Cloud workspace and GitHub project that are created are bound together to provide a GitOps workflow.  This done through a Terraform module.  Similarly,  the created workspaces is configured by another Terraform module.  Finally, the code creates Sentinel policies and binds them to the created Terraform Cloud workspace.

**Please Note**: The code herein is demonstration code.  It is not production grade.  Please use this code as an example of how Terraform Cloud workspace creation can be automated.

## Structure

The project itself is a single level and is broken into a number of files.

### <span>variables.tf</span>

The variables file contains the variables required to run the terraform in the project.  The variables are defined in this files but the values provided are stored in te Terraform Cloud workspace tied to the project.  See more in the [Environment](#Environment) section.

The variables defined in this section do two things:

* Provide security credentials to connect to the providers, Terraform Cloud and GitHub.
* Provide input variables to the modules which configure the workspaces created.  

### <span>providers.tf</span>

The providers file contains the providers for Terraform Cloud and GitHub.  The Terraform modules referenced will inherit these providers to create and manipulate the resources generated in Terraform Cloud and GitHub.  The providers are configured by information stored as variables in the Terraform Cloud workspace.

### <span>test_project.tf</span>

The test project file is a sample on a file onboarding a project.  Modules are instantiated from the Terraform Cloud Private Module Registry.  The modules in use in this file are demo modules the code for which is shared publicly.

#### The Workspace and Repo Module

The first module called builds a Terraform Cloud workspace and a GitHub repo and ties them together for GitOps automation.  The source code for the module is located [here](https://github.com/malekai101/terraform-github-developer-repo).  The GitHub repo is created from a template and can have default code provided in the repository.  For example, in a more robust implementation of the module, template code could be provided for developers based on input parameters.  A corresponding Terraform Cloud workspace is created and configured to process on commits to the Main branch of the workspace.  A more robust implementation of this module might include notifications, RBAC configuration, or Terraform version.

#### The Configuration Modules

The next two modules called configure the workspace that has been created.  Once the workspace is created, the workspace ID is passed to the configuration modules.  In this case the workspace will be used to build infrastructure in Azure and AWS so AWS and Azure configuration modules are used.  These modules configure credentials and default variables for the workspaces needed to work in their respective cloud environments.  The values for these settings are provided by private variables in the Main workspace.  The code for the [Azure](https://github.com/malekai101/terraform-tfe-workspace-config-aws) and [AWS](https://github.com/malekai101/terraform-tfe-workspace-config-azure) modules is shared publicly.

### <span>sentinel.tf</span>

The Sentinel file defines Sentinel policy as code policy sets and attaches them to the created workspace.  In this project, the Sentinel policies are defined in the project and projects are added to the policies as they are created.  This approach couples Sentinel policy definition and workspace creation together.  See the [Alternate Approaches](#Alternate-Approaches) section for other possible architectures.

### <span>variables.tf</span>

The variables file contains the definition but not values for the variables used by the project.  The variable values are populated by the man workspace.  See the documentation in the file itself for variable usage.

## Environment

The code in this repository would be tied to a Terraform Cloud workspace.  In the introduction we referred to this as the Main workspace.  The Main workspace stores the state for the workspace automation project and the variables to connect to TFC, GitHub, and the various cloud environments to which the workspaces will have access.  Due to the state and variable information, the Main workspace should be locked down to an administrative users.  

This kind of project adds a workspaces as new projects are on-boarded.  As new projects (workspaces) are added, the blast radius for a potential error grows larger.  Deleted files or improper updates could rebuild or delete existing workspaces.  As such, the workspace should also be protected against accidental deletions of the workspaces that it creates.  This is best done with Hashicorp Sentinel.  A policy can be put in place that requires user intervention to delete workspaces.  There are standalone and [module based](https://github.com/hashicorp/terraform-guides/blob/master/governance/third-generation/cloud-agnostic/prevent-destruction-of-prohibited-resources.sentinel) sample policies to protect against deleting workspaces.  The policy would be applied with a soft mandatory [enforcement level](https://docs.hashicorp.com/sentinel/concepts/enforcement-levels) requiring approval before making changes.

## Usage

The kind of project would be managed manually by an administrator.  The administrator would add new project files like <span>test_project.rf</span> which contain instantiations of modules for the new workspaces and modules for workspace configuration.  The project would be tied to a GitHib project, commits and pull requests to the main branch would trigger Terraform applies and workspace creation.  The workspace id field would be added to the Sentinel policies in the <span>sentinel.tf</span> file.

To turn down a project, the administrator would remove the tf file for the project and remove references in the <span>sentinel.tf</span> file.  If a Sentinel policy is in place to protect against the deletion, the administrator would need to approve the changes.

## Alternate Approaches

As stated in the beginning of this documentation, this code is demonstration code.  One could build upon this foundation but there are other approaches which are more robust and offer more flexibility.

### Triggered Workspaces

One way to make the Terraform managed by Terraform approach more robust is to use [run triggers](https://www.terraform.io/docs/cloud/workspaces/run-triggers.html).  Rather than defining and running everything in one workspace, duties could be separated out into multiple workspaces which trigger applies in one another.  For example, in this example the Sentinel policies are defined in the same project as the workspaces and GitHub repositories.  This might not be optional from a separation of duties and least privilege perspective.  Instead of defining everything on one project, the Sentinel policy Terraform code could be in another project and configured to execute when the main workspace executes.  In that workflow, workspaces could be created with tags and the Sentinel workspace would assign policies based on those tags.

### The API

Another approach to automating workspace creation is through the [Terraform Cloud API](https://www.terraform.io/docs/cloud/api/index.html).  Instead of using a stateful approach with Terraform, one could build automation using another programming language an call Terraform's API endpoints to build and configure workflows.  This allows for more agility but is an imperative rather than declarative approach.  This would complicate the code and maintenance but it is an approach that some take.