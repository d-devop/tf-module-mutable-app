resource "aws_iam_policy" "ssm-policy" {
  name        = "${var.env}-ssm-to-ec2-${var.component}"
  path        = "/"
  description = "${var.env}-ssm-to-ec2-${var.component}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
  {
    "Sid" : "VisualEditor0",
    "Effect" : "Allow",
    "Action" : [
    "ssm:GetParameterHistory",
    "ssm:GetParametersByPath",
    "ssm:GetParameters",
    "ssm:GetParameter"
  ],
    "Resource" : [
    "arn:aws:ssm:us-east-1:136168207246:parameter/param.dev*",
    "arn:aws:ssm:us-east-1:136168207246:parameter/param.NEXUS*"
  ]
  },
  {
    "Sid" : "VisualEditor1",
    "Effect" : "Allow",
    "Action" : "ssm:DescribeParameters",
    "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2-role" {
  name = "${var.env}-ec2-${var.component}"

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

  tags = {
    tag-key = "${var.env}-ec2-${var.component}"
  }
}

resource "aws_iam_role_policy_attachment" "ssm-role-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.ssm-policy.arn
}

resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "${var.env}-ec2-${var.component}"
  role = aws_iam_role.ec2-role.name
}
