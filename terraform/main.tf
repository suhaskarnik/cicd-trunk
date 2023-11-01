locals {
  environments = ["dev"] 
}

module "lambda" {
  source = "./lambda"
  
  for_each = locals.environments

  env_name = each.key
}