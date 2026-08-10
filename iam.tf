data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "beanflow-notification-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_sqs" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [
      aws_sqs_queue.discord.arn,
      aws_sqs_queue.slack.arn
    ]
  }
}

resource "aws_iam_role_policy" "lambda_sqs" {
  name = "beanflow-lambda-sqs-policy"
  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.lambda_sqs.json
}

