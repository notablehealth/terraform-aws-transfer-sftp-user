<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# terraform-aws-transfer-sftp-user

[![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-aws-transfer-sftp-user)](https://github.com/notablehealth/terraform-aws-transfer-sftp-user/releases)

[Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/transfer-sftp-user/aws)

Terraform module to manage AWS transfer service user

Directory mappings are not fully supported currently

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
    source = "notablehealth/<module-name>/aws"
    # Recommend pinning every module to a specific version
    # version = "x.x.x"

    # Required variables
        aws_transfer_server_id =
        s3_bucket_name =
        sftp_user =
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.64 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_label"></a> [iam\_label](#module\_iam\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3_access_for_sftp_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.s3_access_for_sftp_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_object.additional_directories](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.home_directory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_transfer_ssh_key.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key) | resource |
| [aws_transfer_user.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_access_for_sftp_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_transfer_server_id"></a> [aws\_transfer\_server\_id](#input\_aws\_transfer\_server\_id) | AWS Transfer Server ID | `string` | n/a | yes |
| <a name="input_create_home_folder"></a> [create\_home\_folder](#input\_create\_home\_folder) | Create S3 object for user home folder | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the default S3 bucket | `string` | n/a | yes |
| <a name="input_sftp_user"></a> [sftp\_user](#input\_sftp\_user) | Map of sftp user objects | <pre>object({<br>    user_name       = string,<br>    public_key      = optional(set(string), []),<br>    add_directories = optional(set(string), []),<br>    home_directory  = optional(string),<br>    home_directory_mappings = optional(list(object({<br>      entry  = string,<br>      target = string<br>    })), []),<br>    policy          = optional(string),<br>    restricted_home = optional(bool, true),<br>    role            = optional(string),<br>    s3_bucket_name  = optional(string),<br>    tags            = optional(map(string)),<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_directory_mappings"></a> [directory\_mappings](#output\_directory\_mappings) | Home directory mappings for the user |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
