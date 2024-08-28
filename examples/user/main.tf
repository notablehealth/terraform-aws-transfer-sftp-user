module "transfer-user" {
  source = "../.."

  aws_transfer_server_id = var.aws_transfer_server_id
  create_home_folder     = true
  #create_mapping_targets = true
  s3_bucket_name = var.s3_bucket_name
  sftp_user = {
    user_name = "test-user"
    #add_directories = ["one", "two", "three"]
    #home_directory = "/${var.s3_bucket_name}/test-user",
    home_directory_mappings = [
      {
        entry  = "/map/1",
        target = "/${var.s3_bucket_name}/test-map-1"
      },
      {
        entry  = "/map/2",
        target = "/${var.s3_bucket_name}/test-map-2"
      }
    ],
    restricted_home = false
    #public_key      = ["rsa-sha 1234", "rsa-sha 5678"]
    #s3_bucket_name = var.s3_bucket_name
  }
}
