variable "add_reported_income_root" {
  type = string
  default = "../app/add_reported_income"
}

resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${var.add_reported_income_root}/requirements.txt -t ${var.add_reported_income_root}/ --upgrade"
  }
  triggers = {
    dependencies_versions = filemd5("${var.add_reported_income_root}/requirements.txt")
    source_versions = filemd5("${var.add_reported_income_root}/handler.py")
  }
}

data "archive_file" "artifact_add_reported_income" {
  depends_on = [
    null_resource.install_dependencies
  ]
  type = "zip"
  source_dir = "${var.add_reported_income_root}"
  output_path = "../deploy/artifacts/add-reported-income.zip"
}

resource "aws_s3_object" "artifact_add_reported_income" {
    bucket = aws_s3_bucket.artifact_storage.id
    key = "add-reported-income.zip"
    source = data.archive_file.artifact_add_reported_income.output_path
    etag = filemd5(data.archive_file.artifact_add_reported_income.output_path)
}

resource "aws_lambda_function" "add_reported_income" {
    function_name = "add_reported_income"

    s3_bucket = aws_s3_bucket.artifact_storage.id
    s3_key = aws_s3_object.artifact_add_reported_income.key

    runtime = "python3.9"
    handler = "handler.lambda_handler"

    source_code_hash = data.archive_file.artifact_add_reported_income.output_base64sha256

    role = aws_iam_role.lambda_exec.arn
}