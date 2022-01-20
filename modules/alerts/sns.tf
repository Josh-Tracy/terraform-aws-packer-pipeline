# Add SNS topic subscription
resource "aws_sns_topic" "build_updates" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.build_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}


resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.build_updates.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.build_updates.arn]
  }
}
