# FIRO Portal Deployment on Google Cloud

## Prerequisites

- gcloud SDK (https://cloud.google.com/sdk/docs/install-sdk)
- gcloud auth login (https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login)
- Terraform (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


## Terraform Workspaces
When running terraform, a state file is created that tracks resources and variables for the latest deployment.
Workspaces allow the users to redeploy resources with the same credentials in a new state that is tracked separately.
A common use case of this is for production, staging, and dev environments. Users can easily switch between workspaces
to track what resources can be found in each environment and rerun applys/plans as necessary.

- Create a new terraform workspace
```bash
terraform workspace new <workspace_name>
```
- Switch to the newly created workspace
```bash
terraform workspace select <workspace_name>
```
- Confirm selected workspace
```bash
terraform workspace show
```


## Using env files

When running terraform, you can use environment files to provide terraform with environment specific variable values.
In the envs folder, there is a default.tfvars with the variables that will be used. Copy this file and rewrite the
values for the environment you are working on. 

In order to run terraform with the env variable file, do the following:

```bash
terraform apply --var-file="envs/prod.tfvars"
```