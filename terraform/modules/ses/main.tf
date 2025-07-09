resource "aws_ses_email_identity" "this" {
  for_each = toset(var.email_identities)
  email    = each.value
}
