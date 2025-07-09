# Most useful values for downstream consumers
############################################

# 1. HTTPS invoke URL (stage base URL) – use it in your front-end
output "api_endpoint" {
  description = "Invoke URL for POST /contact"
  value       = module.apigw.invoke_url
}

# 2. Name of the deployed Lambda function (handy for CloudWatch logs console link)
output "lambda_function_name" {
  description = "Physical name of the Lambda function"
  value       = module.lambda.function_name != null ? module.lambda.function_name : "contact-form-handler"
}

# 3. DynamoDB table name so you can query it from the console or scripts
output "dynamodb_table_name" {
  value       = module.dynamodb.table_arn
  description = "DynamoDB table where contact submissions are stored"
}

# 4. SES identity ARN (proof that verification succeeded)
output "ses_identity_arn" {
  value       = module.ses.identity_arns
  description = "ARN of the verified SES e-mail identity used for notifications"
}
