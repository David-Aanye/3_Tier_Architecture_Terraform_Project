#IAM role for vpc flow logs
resource "aws_iam_role" "vpc-logs-monitoring" {

  name = "test-vpc-flow-logs"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "vpc-flow-logs.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


#IAM policy for vpc flow logs
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-flow-l0g-policy"
  role = aws_iam_role.vpc-logs-monitoring.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

#Cloudwatch configurations for vpc flow logs
resource "aws_cloudwatch_log_group" "test_flow_logs_group" {
  name         = "cloudwatch_log_group"
  skip_destroy = false
  deletion_protection_enabled = false
}

resource "aws_cloudwatch_log_stream" "test_log_stream" {
  name           = "cloudwatch_log_stream"
  log_group_name = aws_cloudwatch_log_group.test_flow_logs_group.name
}

# Vpc flow logs resource
resource "aws_flow_log" "vpc" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.test_flow_logs_group.arn
  iam_role_arn         = aws_iam_role.vpc-logs-monitoring.arn
  vpc_id               = aws_vpc.terra.id
  traffic_type         = "ALL"


}

  