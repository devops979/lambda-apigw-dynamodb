# ------------------------------------------------------------
# IAM Trust Policy Document for Lambda
# ------------------------------------------------------------
# This data block defines a trust relationship that allows AWS Lambda
# to assume the IAM role. It uses the sts:AssumeRole action and specifies
# Lambda as the trusted service.
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ------------------------------------------------------------
# IAM Role for Lambda Execution
# ------------------------------------------------------------
# This resource creates an IAM role named "contact_lambda_exec"
# and attaches the trust policy defined above. Lambda will assume
# this role during execution.
resource "aws_iam_role" "lambda_exec" {
  name               = "contact_lambda_exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

# ------------------------------------------------------------
# Inline IAM Policy Document for Lambda Permissions
# ------------------------------------------------------------
# This data block defines the permissions Lambda needs:
# - Access to DynamoDB (PutItem, DescribeTable)
# - Ability to send emails via SES
# - Full access to CloudWatch Logs
data "aws_iam_policy_document" "inline" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:PutItem", "dynamodb:DescribeTable"]
    resources = [var.dynamodb_arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# ------------------------------------------------------------
# Attach Inline Policy to IAM Role
# ------------------------------------------------------------
# This resource attaches the inline policy defined above to the
# IAM role created for Lambda. This grants Lambda the necessary
# permissions to interact with DynamoDB, SES, and CloudWatch Logs.
resource "aws_iam_role_policy" "inline" {
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.inline.json
}
