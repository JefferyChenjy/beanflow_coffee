# This file is used to create an IAM policy document for the SQS queue that allows SNS to send messages to it.
data "aws_iam_policy_document" "discord_queue_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.discord.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        aws_sns_topic.order_events.arn
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "discord" {
  queue_url = aws_sqs_queue.discord.url
  policy    = data.aws_iam_policy_document.discord_queue_policy.json
}