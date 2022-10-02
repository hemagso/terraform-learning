resource "aws_s3_bucket" "artifact_storage" {
    bucket = "artifact-storage"
}

resource "aws_s3_bucket_acl" "artifact_storage_acl" {
    bucket = aws_s3_bucket.artifact_storage.id
    acl = "private"
}