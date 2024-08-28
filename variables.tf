
#variable "validated" {
#  description = "String variable with validation"
#  type        = string
#  validation {
#    condition = contains(
#      ["one", "two", "three", "four"],
#      var.validated
#    )
#    error_message = "Must be one of: one, two, three, four."
#  }
#}

variable "aws_transfer_server_id" {
  description = "AWS Transfer Server ID"
  type        = string
}
variable "create_home_folder" {
  description = "Create S3 object for user home folder"
  type        = bool
  default     = false
}
#variable "create_mapping_targets" {
#  description = "Create S3 objects for directory mapping targets"
#  type        = bool
#  default     = false
#}
variable "s3_bucket_name" {
  description = "Name of the default S3 bucket"
  type        = string
}

variable "sftp_user" {
  description = "Map of sftp user objects"
  type = object({
    user_name       = string,
    public_key      = optional(set(string), []),
    add_directories = optional(set(string), []),
    home_directory  = optional(string),
    home_directory_mappings = optional(list(object({
      entry  = string,
      target = string
    })), []),
    policy          = optional(string),
    restricted_home = optional(bool, true),
    role            = optional(string),
    s3_bucket_name  = optional(string),
    tags            = optional(map(string)),
  })

  validation { # add dirs not compatible with dir mapping
    condition     = !(length(var.sftp_user.add_directories) > 0 && length(var.sftp_user.home_directory_mappings) > 0)
    error_message = "add_directories and home_directory_mappings cannot be used together."
  }

  validation { # home_directory_mappings entries cannot contain each other
    condition = !anytrue(flatten([
      for map1 in var.sftp_user.home_directory_mappings : [
        for map3 in setsubtract(
          [for map2 in var.sftp_user.home_directory_mappings : map2.entry],
          [map1.entry]
        ) : startswith(map3, map1.entry)
      ]
    ]))
    error_message = "Directory mapping entry paths cannot overlap. In directory terms, no entry can be the parent of another entry."
  }
  validation { # Validate home_directory_mappings are unique
    condition     = length(var.sftp_user.home_directory_mappings) == length(distinct(var.sftp_user.home_directory_mappings[*].entry))
    error_message = "Each directory mapping entry must be unique."
  }
  validation { # home_directory only if not restricted_home or home_directory_mappings
    condition     = !(var.sftp_user.home_directory != null && (var.sftp_user.restricted_home || length(var.sftp_user.home_directory_mappings) > 0))
    error_message = "home_directory can only be set if restricted_home and home_directory_mappings are not used."
  }
  validation { # Only one of restricted_home or home_directory_mappings
    condition     = !(var.sftp_user.restricted_home && length(var.sftp_user.home_directory_mappings) > 0)
    error_message = "restricted_home and home_directory_mappings cannot be used together."
  }
}
