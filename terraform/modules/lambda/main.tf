data "archive_file" "package" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source_file = var.handler_file
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  filename         = data.archive_file.package.output_path
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.package.output_base64sha256
  runtime          = "python3.12"
  role             = var.role_arn

  environment {
    variables = {
      TABLE_NAME    = var.table_name
      FROM_ADDRESS  = var.from_address      # verified SES sender
      ALERT_ADDRESS = var.alert_address     # verified SES recipient
    }
  }
}
