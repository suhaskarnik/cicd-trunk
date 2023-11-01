locals {
  environments = ["dev", "test", "prod"] 
  tags = {
    "Project": "cicd-trunk"
  }
}

data "archive_file" "app" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/app.zip"
}


module "lambda" {
  source = "./lambda"
  archive_file = data.archive_file.app
  tags = local.tags

  for_each = toset(local.environments)  

  env_name = each.key
}


output "lambda_arns" {
  value = {
    for module_key, module_instance in module.lambda :
      module_key => module_instance.lambda_arn
  }
}