output "api_id" {
  value       = aws_api_gateway_rest_api.this.id
  description = "The ID of the created API Gateway REST API."
}

output "api_endpoint" {
  value       = aws_api_gateway_stage.this.invoke_url
  description = "The base URL of the deployed API Gateway stage."
}

output "deployment_id" {
  value       = aws_api_gateway_deployment.this.id
  description = "The ID of the API Gateway deployment."
}

output "stage_name" {
  value       = aws_api_gateway_stage.this.stage_name
  description = "The name of the API Gateway stage."
}

output "lambda_integration_uri" {
  value       = aws_api_gateway_integration.lambda_integration.uri
  description = "The URI used by API Gateway to invoke the Lambda function."
}
