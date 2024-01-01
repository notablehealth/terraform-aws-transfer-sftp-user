<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# terraform-aws-transfer-sftp-user

[![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-aws-transfer-sftp-user)](https://github.com/notablehealth/terraform-aws-transfer-sftp-user/releases)

[Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/transfer-sftp-user/aws)

Terraform module to manage AWS transfer service user

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
    source = "notablehealth/<module-name>/aws"
    # Recommend pinning every module to a specific version
    # version = "x.x.x"

    # Required variables
    sftp_users =
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.11.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_sftp_users"></a> [sftp\_users](#input\_sftp\_users) | Map of sftp user objects | <pre>map(object({<br>    user_name  = string,<br>    public_key = string<br>    #home_directory_type = optional(string), # "PATH" or "LOGICAL"<br>    #home_directory = optional(string),<br>    # Need a create endpoints/targets option (global default))<br>    #home_directory_mappings = optional(list(object({<br>    #  entry = string,<br>    #  target = string<br>    #}))),<br>    #folders = optional(list(string))) # Support in main<br>    #tags = optional(map(string)) # Enhance module<br>    #policy = optional(string) # Enhance module<br>    #role = optional(string) # Enhance module<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
