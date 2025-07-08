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
  notify_email  = var.notify_email
}

module "apigw" {
  source     = "./modules/apigw"
  lambda_arn = module.lambda.lambda_arn
}

module "ses" {
  source         = "./modules/ses"
  email_identity = var.notify_email
}
