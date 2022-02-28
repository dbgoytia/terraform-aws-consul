variable "iam_role_id" {
  description = "IAM role to associate to the Consul policy"
  type        = string
}

variable "region" {
  description = "Deployment region of the cluster"
  type        = string
}
