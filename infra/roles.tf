resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}


resource "aws_iam_policy" "write_reported_income_table" {
  name = "APPWriteReportedIncomeTable"
  path = "/"
  description = "Allow writing new income reports to DynamoDB Table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGet*",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTable",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWrite*",
          "dynamodb:CreateTable",
          "dynamodb:Delete*",
          "dynamodb:Update*",
          "dynamodb:PutItem"
        ]
        Resource = aws_dynamodb_table.reported_income_table.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "hail_mary" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_execution" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_write_reported_income" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.write_reported_income_table.arn
}
