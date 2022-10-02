resource "aws_dynamodb_table" "reported_income_table" {
  name = "reported_income"
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "report_id"
  range_key = "customer_id"

  attribute {
    name = "report_id"
    type = "S"
  }

  attribute {
    name = "customer_id"
    type = "S"
  }

  global_secondary_index {
    name = "customer_index"
    hash_key = "customer_id"
    range_key = "report_id"
    write_capacity = 1
    read_capacity = 1
    projection_type = "ALL"
  }
}