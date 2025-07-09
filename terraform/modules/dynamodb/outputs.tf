output "table_arn" {
  description = "The Amazon Resource Name (ARN) of the DynamoDB table created, used for referencing the table in IAM policies or other AWS resources."
  value       = aws_dynamodb_table.this.arn
}
