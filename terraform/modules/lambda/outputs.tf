output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "The Amazon Resource Name (ARN) of the deployed AWS Lambda function."
}


output "function_name" {
  value       = aws_lambda_function.this.function_name
  description = "The name of the deployed AWS Lambda function."
}