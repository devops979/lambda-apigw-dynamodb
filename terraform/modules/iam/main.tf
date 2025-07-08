data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals { type = "Service" identifiers = ["lambda.amazonaws.com"] }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "contact_lambda_exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "inline" {
  statement {
    effect   = "Allow"
    actions  = ["dynamodb:PutItem", "dynamodb:DescribeTable"]
    resources = [var.dynamodb_arn]
  }
  statement {
    effect = "Allow"
    actions = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "inline" {
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.inline.json
}
