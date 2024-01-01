
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

#variable "simple" {
#  description = "Simple string variable"
#  type        = string
#  default     = "text"
#}

variable "sftp_users" {
  type = map(object({
    user_name  = string,
    public_key = string
    #home_directory_type = optional(string), # "PATH" or "LOGICAL"
    #home_directory = optional(string),
    # Need a create endpoints/targets option (global default))
    #home_directory_mappings = optional(list(object({
    #  entry = string,
    #  target = string
    #}))),
    #folders = optional(list(string))) # Support in main
    #tags = optional(map(string)) # Enhance module
    #policy = optional(string) # Enhance module
    #role = optional(string) # Enhance module
  }))
  description = "Map of sftp user objects"
}
