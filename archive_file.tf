data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/./lambda/index.mjs"
  output_path = "${path.module}/lambda.zip"
}