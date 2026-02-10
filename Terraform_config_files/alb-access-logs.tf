#S3 bucket for ALB access logs
resource "aws_s3_bucket" "alb_logs" {
  bucket        = "my-ex-alb-logs-bucket"
  force_destroy = true

  tags = {
    Name = "my-ex-alb-logs"
  }
}

#Bucket policy to access bucket for storing ALB access logs
resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logdelivery.elasticloadbalancing.amazonaws.com"
        },

        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::my-ex-alb-logs-bucket/ACL/AWSLogs/656435924275/*"
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:elasticloadbalancing:ca-central-1:656435924275:loadbalancer/*"
          }
        }

      }
    ]
  })

}

 