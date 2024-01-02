
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
variable "create_mapping_targets" {
  description = "Create S3 objects for directory mapping targets"
  type        = bool
  default     = false
}

variable "sftp_user" {
  description = "Map of sftp user objects"
  type = object({
    user_name      = string,
    public_key     = list(string),
    folders        = optional(list(string)),
    home_directory = optional(string),
    home_directory_mappings = optional(list(object({
      entry  = string,
      target = string
    }))),
    home_directory_type = optional(string, "LOGICAL"),
    policy              = optional(string),
    restricted_home     = optional(bool, true),
    role                = optional(string),
    s3_bucket_name      = optional(string),
    tags                = optional(map(string)),
  })
  # restricted or map AND LOGICAL
  # PATH AND NOT restricted or map
  # s3_bucket_name AND PATH

  validation {
    condition = contains(
      ["LOGICAL", "PATH"],
      var.sftp_user.home_directory_type
    )
    error_message = "Must be one of: LOGICAL, PATH."
  }
}
