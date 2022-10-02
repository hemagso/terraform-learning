data "archive_file" "artifact_get_reported_income" {
  type = "zip"
  source_dir = "../${path.module}/app/get_reported_income"
  output_path = "../${path.module}/deploy/artifacts/get-reported-income.zip"
}

resource "aws_s3_object" "artifact_get_reported_income" {
    bucket = aws_s3_bucket.artifact_storage.id
    key = "get-reported-income.zip"
    source = data.archive_file.artifact_get_reported_income.output_path
    etag = filemd5(data.archive_file.artifact_get_reported_income.output_path)
}

resource "aws_lambda_function" "get_reported_income" {
    function_name = "get_reported_income"

    s3_bucket = aws_s3_bucket.artifact_storage.id
    s3_key = aws_s3_object.artifact_get_reported_income.key

    runtime = "python3.9"
    handler = "handler.lambda_handler"

    source_code_hash = data.archive_file.artifact_get_reported_income.output_base64sha256

    role = aws_iam_role.lambda_exec.arn
}