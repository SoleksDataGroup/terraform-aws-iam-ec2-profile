// Module: terraform-aws-iam-ec2-profile
// Description: terraform-aws-iam-ec2-profile module input variables
//

variable "name_prefix" {
  description     = "IAM EC2 profile name prefix"
  type            = string
  default         = "generic"
}

variable "iam_policy_statements" {
  description = "IAM policy statements"
  type = list(object({
    action = list(string)
    effect = string
    resources = list(string)
  }))
  default = []
}
