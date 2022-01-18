# Add SNS topic subscription
resource "aws_sns_topic" "build_updates" {
  name = "build-updates"
}

resource "aws_cloudwatch_event_rule" "build" {
  name        = "build-complete"
  description = "Alert on status of Packer pipeline"

  event_pattern = <<EOF
{
  "detail-type": [
    "AmiBuilder"
  ],
  "source": [
    "com.ami.builder"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.build.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.build_updates.arn
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
