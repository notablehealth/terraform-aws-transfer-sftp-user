# terraform-aws-module-template

[![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-aws-module-template)](https://github.com/notablehealth/terraform-aws-module-template/releases)

[Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/module-template/aws)

Template for creating a Terraform module for AWS

## Features

- base terraform files
- pre-commit setup
- GitHub actions setup

## Usage

Copy contents or create new repository on GitHub and use this as a template

```hcl
module "MODULE-NAME" {
  source  = "ORGANIZATION/MODULE-NAME/aws"
  # Recommend pinning every module to a specific version
  # version = "x.x.x"

}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.53.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
