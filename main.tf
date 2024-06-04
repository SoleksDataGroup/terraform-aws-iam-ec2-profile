data "aws_iam_policy_document" "ec2_iam_policy_document" {
  dynamic "statement" {
    for_each = var.iam_policy_statements
    content {
      actions = lookup(statement.value, "actions", [])
      resources = lookup(statement.value, "resources", ["*"])
      effect = lookup(statement.value, "effect", "")
    }
  }
}

resource "aws_iam_policy" "ec2_iam_policy" {
  name        = "${var.name_prefix}-iam-policy"

  policy = data.aws_iam_policy_document.ec2_iam_policy_document.json

}

resource "aws_iam_policy" "ec2_iam_policy_old" {
  name        = "${var.name_prefix}-iam-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      }, 
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::talkscriber-nvidia",
          "arn:aws:s3:::talkscriber-nvidia/*",
        ]
      },
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::ts-postgres",
          "arn:aws:s3:::ts-postgres/*",
        ]
      },
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = [ "*" ]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "${var.name_prefix}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_iam_attachment" {
  name       = "${var.name_prefix}-iam-attachment"
  roles      = [aws_iam_role.iam_role.name]
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "${var.name_prefix}-iam-profile"
  role = aws_iam_role.iam_role.name
}
