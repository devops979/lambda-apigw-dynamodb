output "identity_arns" {
  description = "Map of verified SES email identities and their ARNs."
  value       = { for email, identity in aws_ses_email_identity.this : email => identity.arn }
}
