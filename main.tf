provider "aws" {
  region = var.aws_region
}

provider "random" {}

resource "random_pet" "table_name" {}

resource "aws_dynamodb_table" "tfc_example_table" {
  name = "${var.db_table_name}-${random_pet.table_name.id}"

  read_capacity  = var.db_read_capacity
  write_capacity = var.db_write_capacity
  hash_key       = "UUID"

  attribute {
    name = "UUID"
    type = "S"
  }
}

module "wiz" {
  source        = "https://s3-us-east-2.amazonaws.com/wizio-public/deployment-v2/aws/wiz-aws-native-terraform-terraform-module.zip"
  external-id   = "b1af0ff4-f15b-46f0-aa77-d928f254babe"
  data-scanning = true
  lightsail-scanning = false
  eks-scanning         = true
  remote-arn    = "arn:aws:iam::197171649850:role/prod-us20-AssumeRoleDelegator"
}

output "wiz_connector_arn" {
  value = module.wiz.role_arn
}
