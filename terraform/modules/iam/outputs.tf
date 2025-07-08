output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role assigned to the Lambda function, used for execution permissions."
  value       = aws_iam_role.lambda_exec.arn 
}
