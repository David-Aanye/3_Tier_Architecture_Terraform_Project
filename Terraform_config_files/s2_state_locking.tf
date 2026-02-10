#IAM role for s3 state locking
resource "aws_iam_role" "s3_access_state_locking" {
  name = "s3-state-locking-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::656435924275:root" // Replace with the trusted account ID or specific IAM user/role ARN
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

#IAM policy for s3 state locking
resource "aws_iam_policy" "state_locking_role" {
  name = "s3-access-state-locking-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {

        "Sid" : "S3StateAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::maabo-bucket-remote-tfstate",
          "arn:aws:s3:::maabo-bucket-remote-tfstate/*"
        ]
      },
      {
        "Sid" : "S3LockingSupport",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObjectAttributes",
          "s3:GetObjectVersion",
          "s3:PutObjectVersionAcl",
          "s3:ListBucketVersions"
        ],
        "Resource" : [
          "arn:aws:s3:::maabo-bucket-remote-tfstate",
          "arn:aws:s3:::maabo-bucket-remote-tfstate/*"
        ]
      }
    ]
  })
}

#IAm policy attachment for s3 state locking
resource "aws_iam_role_policy_attachment" "s3_state_locking" {
  role       = aws_iam_role.s3_access_state_locking.name
  policy_arn = aws_iam_policy.state_locking_role.arn
}




