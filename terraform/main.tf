module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name
}

module "iam" {
  source       = "./modules/iam"
  dynamodb_arn = module.dynamodb.table_arn
}

module "lambda" {
  source        = "./modules/lambda"
  function_name = "contact-form-handler"
  role_arn      = module.iam.role_arn
  handler_file  = "${path.module}/../lambda_src/handler.py"
  table_name    = var.table_name  
  from_address  = "devops979@gmail.com"
  alert_address = "anilcharan357@gmail.com"

}

module "apigw" {
  source                      = "./modules/apigw"
  api_name                    = "contact-api"
  description                 = "API Gateway REST API for contact form"
  lambda_function_arn         = module.lambda.lambda_arn
  aws_region                  = var.aws_region
  stage_name                  = "prod"
  stage_description           = "Production stage for contact API"
  access_log_destination_arn = var.access_log_destination_arn
  access_log_format           = var.access_log_format
  tags                        = var.tags
}

module "ses" {
  source           = "./modules/ses"
  email_identities = [
    "devops979@gmail.com",
    "anilcharan357@gmail.com"
  ]
}
