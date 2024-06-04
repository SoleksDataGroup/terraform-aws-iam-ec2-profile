// Module: terraform-aws-iam-ec2-profile
// Description: terraform-aws-iam-ec2-profile module output variables
//

output "arn" {
  description = "EC2 instance IAM profile arn"
  value = aws_iam_instance_profile.ec2_iam_profile.arn
}
