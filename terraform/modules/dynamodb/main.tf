# ------------------------------------------------------------
# DynamoDB Table Resource
# ------------------------------------------------------------
# Creates a DynamoDB table with on-demand billing and a single
# string-type primary key named "id".
resource "aws_dynamodb_table" "this" {
  name         = var.table_name              # Table name from variable
  billing_mode = "PAY_PER_REQUEST"           # On-demand billing (no need to specify read/write capacity)

  hash_key     = "id"                         # Primary key (partition key)

  attribute {
    name = "id"
    type = "S"                                # Attribute type: S = String
  }
}
