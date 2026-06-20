//Trust policy: who can assume this role

data "aws_iam_policy_document" "ec2_trust" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

//Role definition
resource "aws_iam_role" "ec2_role" {
    name = "${var.environment}-ec2-role"
    assume_role_policy = data.aws_iam_policy_document.ec2_trust.json

    tags = {
        Name = "${var.environment}-ec2-role"
        Environment = var.environment
    }
}

// Permission policy: what permissions the role has
data "aws_iam_policy_document" "read" {
    statement {
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:ListBucket"
        ]
        resources = ["*"]
    }
}

resource "aws_iam_policy" "s3_read" {
    name = "${var.environment}-s3-read"
    policy = data.aws_iam_policy_document.read.json
}

//Attach the permission policy to the role
resource "aws_iam_role_policy_attachment" "s3_read" {
    role = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.s3_read.arn
}

// Instance profile: allows EC2 instances to use the role
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${var.environment}-ec2-instance-profile"
    role = aws_iam_role.ec2_role.name
}
